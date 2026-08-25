pipeline {

    agent none

    parameters {

        string(
            name: 'Env',
            defaultValue: 'Test',
            description: 'Environment to deploy'
        )

        booleanParam(
            name: 'executeTests',
            defaultValue: true,
            description: 'Run Laravel tests'
        )

        choice(
            name: 'APPVERSION',
            choices: ['1.1', '1.2', '1.3'],
            description: 'Select application version'
        )

        booleanParam(
            name: 'pushImage',
            defaultValue: true,
            description: 'Push image to Docker Hub'
        )

        booleanParam(
            name: 'pruneOldImages',
            defaultValue: true,
            description: 'Remove dangling/old images after deploy'
        )

        booleanParam(
            name: 'useSecureEnv',
            defaultValue: true,
            description: 'Use Jenkins-managed .env credential (recommended). If false, falls back to /home/ubuntu/.env.ecommerce-card on the server.'
        )
    }

    environment {

        // Ubuntu server
        BUILD_SERVER = 'ubuntu@192.168.137.207'

        // Docker Hub
        IMAGE_NAME = "menghieng002/ecommerce-card:${BUILD_NUMBER}"

        // Container name
        CONTAINER_NAME = 'ecommerce-card'

        // Healthcheck URL after deploy
        HEALTHCHECK_URL = 'http://192.168.137.207/healthcheck'

        // How many old images to keep when pruning
        KEEP_IMAGES = '3'

        // Jenkins credential ID for the .env file (must be a "Secret file" credential)
        ENV_CREDENTIAL_ID = 'laravel-env-production'
    }

    stages {

        // ==========================================
        // Laravel Test
        // ==========================================
        stage('Laravel Test') {

            agent any

            when {
                expression {
                    params.executeTests == true
                }
            }

            steps {

                echo "Running Laravel tests..."

                script {

                    // The Jenkins agent does not have PHP or composer installed,
                    // so run the test stage on the Ubuntu server (which already
                    // has docker for the other stages) via sshagent.
                    sshagent(['slave2']) {

                        sh """
                            ssh -o StrictHostKeyChecking=no \\
                            ${BUILD_SERVER} \\
                            "rm -rf ~/laravel-test && \\
                            git clone --depth 1 \\
                            https://github.com/menghieng-sorn/ecommerce-card.git \\
                            ~/laravel-test && \\
                            cd ~/laravel-test && \\
                            docker pull composer:2 && \\
                            docker run --rm \\
                                -v \\"\$PWD\\":/app \\
                                -w /app \\
                                composer:2 \\
                                composer install \\
                                    --no-interaction \\
                                    --prefer-dist \\
                                    --no-progress && \\
                            docker pull php:8.2-cli && \\
                            docker run --rm \\
                                -v \\"\$PWD\\":/app \\
                                -w /app \\
                                php:8.2-cli \\
                                bash -c \\
                                    'cp .env.example .env && \\
                                    php artisan key:generate && \\
                                    php artisan test'"
                        """

                        sh """
                            ssh -o StrictHostKeyChecking=no \\
                            ${BUILD_SERVER} \\
                            "rm -rf ~/laravel-test"
                        """
                    }
                }
            }
        }


        // ==========================================
        // Build Docker Image
        // ==========================================
        stage('Containerising the App') {

            agent any

            steps {

                script {

                    sshagent(['slave2']) {

                        echo "Copying deployment script to Ubuntu..."

                        sh """
                            scp -o StrictHostKeyChecking=no \
                            server-script.sh \
                            ${BUILD_SERVER}:/home/ubuntu/server-script.sh
                        """

                        if (params.useSecureEnv) {

                            echo "Fetching .env from Jenkins credentials..."

                            withCredentials([
                                file(
                                    credentialsId: env.ENV_CREDENTIAL_ID,
                                    variable: 'JENKINS_ENV_FILE'
                                )
                            ]) {

                                echo "Copying .env to Ubuntu (will be deleted after build)..."

                                sh """
                                    scp -o StrictHostKeyChecking=no \
                                    ${JENKINS_ENV_FILE} \
                                    ${BUILD_SERVER}:/home/ubuntu/.env.build
                                """

                                sh """
                                    ssh -o StrictHostKeyChecking=no \
                                    ${BUILD_SERVER} \
                                    "chmod 600 /home/ubuntu/.env.build && \
                                    ENV_FILE=/home/ubuntu/.env.build \
                                    chmod +x /home/ubuntu/server-script.sh && \
                                    /home/ubuntu/server-script.sh ${IMAGE_NAME} ${APPVERSION}"
                                """

                                echo "Cleaning up .env from server..."

                                sh """
                                    ssh -o StrictHostKeyChecking=no \
                                    ${BUILD_SERVER} \
                                    "shred -u /home/ubuntu/.env.build 2>/dev/null || rm -f /home/ubuntu/.env.build"
                                """
                            }

                        } else {

                            echo "Using server-side .env at /home/ubuntu/.env.ecommerce-card..."

                            sh """
                                ssh -o StrictHostKeyChecking=no \
                                ${BUILD_SERVER} \
                                "chmod +x /home/ubuntu/server-script.sh && \
                                /home/ubuntu/server-script.sh ${IMAGE_NAME} ${APPVERSION}"
                            """

                        }

                        if (params.pushImage) {

                            withCredentials([
                                usernamePassword(
                                    credentialsId: 'docker-hub',
                                    usernameVariable: 'USERNAME',
                                    passwordVariable: 'PASSWORD'
                                )
                            ]) {

                                echo "Logging into Docker Hub..."

                                sh """
                                    ssh -o StrictHostKeyChecking=no \
                                    ${BUILD_SERVER} \
                                    "echo '${PASSWORD}' | sudo docker login \
                                    -u '${USERNAME}' \
                                    --password-stdin"
                                """


                                echo "Pushing Docker image..."

                                sh """
                                    ssh -o StrictHostKeyChecking=no \
                                    ${BUILD_SERVER} \
                                    "sudo docker push ${IMAGE_NAME}"
                                """

                                echo "Tagging image with app version ${APPVERSION}..."

                                sh """
                                    ssh -o StrictHostKeyChecking=no \
                                    ${BUILD_SERVER} \
                                    "sudo docker tag ${IMAGE_NAME} \
                                    menghieng002/ecommerce-card:${APPVERSION} && \
                                    sudo docker push menghieng002/ecommerce-card:${APPVERSION}"
                                """
                            }

                        } else {

                            echo "Skipping Docker Hub push (pushImage=false)."

                        }
                    }
                }
            }
        }


        // ==========================================
        // Deploy
        // ==========================================
        stage('Deploy') {

            agent any

            steps {

                script {

                    sshagent(['slave2']) {

                        echo "Stopping existing container..."

                        sh """
                            ssh -o StrictHostKeyChecking=no \
                            ${BUILD_SERVER} \
                            "sudo docker stop ${CONTAINER_NAME} || true"
                        """

                        echo "Removing existing container..."

                        sh """
                            ssh -o StrictHostKeyChecking=no \
                            ${BUILD_SERVER} \
                            "sudo docker rm ${CONTAINER_NAME} || true"
                        """

                        echo "Starting new container..."

                        sh """
                            ssh -o StrictHostKeyChecking=no \
                            ${BUILD_SERVER} \
                            "sudo docker run -d \
                            --name ${CONTAINER_NAME} \
                            --restart unless-stopped \
                            -p 80:80 \
                            --label app=ecommerce-card \
                            --label version=${APPVERSION} \
                            --label build=${BUILD_NUMBER} \
                            ${IMAGE_NAME}"
                        """

                        if (params.pruneOldImages) {

                            echo "Pruning old images (keeping last ${KEEP_IMAGES})..."

                            sh """
                                ssh -o StrictHostKeyChecking=no \
                                ${BUILD_SERVER} \
                                "sudo docker images menghieng002/ecommerce-card \
                                --format '{{.Tag}} {{.CreatedAt}}' | \
                                sort -k2 -r | tail -n +${KEEP_IMAGES} | \
                                awk '{print \$1}' | \
                                xargs -r -I {} sudo docker rmi \
                                menghieng002/ecommerce-card:{} || true"
                            """

                            sh """
                                ssh -o StrictHostKeyChecking=no \
                                ${BUILD_SERVER} \
                                "sudo docker image prune -f || true"
                            """

                        }
                    }
                }
            }
        }


        // ==========================================
        // Post-deploy Healthcheck
        // ==========================================
        stage('Healthcheck') {

            agent any

            steps {

                echo "Waiting for container to become healthy..."

                script {

                    def healthy = false

                    for (int i = 0; i < 12; i++) {

                        def status = sh(
                            script: """
                                ssh -o StrictHostKeyChecking=no \
                                ${BUILD_SERVER} \
                                "curl -fsS ${HEALTHCHECK_URL} >/dev/null && echo OK || echo FAIL"
                            """,
                            returnStdout: true
                        ).trim()

                        if (status == 'OK') {
                            echo "Healthcheck passed on attempt ${i + 1}."
                            healthy = true
                            break
                        }

                        echo "Healthcheck attempt ${i + 1} not ready yet, retrying in 5s..."
                        sleep 5
                    }

                    if (!healthy) {

                        error "Container failed healthcheck at ${HEALTHCHECK_URL}"
                    }
                }
            }
        }
    }

    post {

        success {
            echo "======================================"
            echo "Laravel deployment successful!"
            echo "Image:     ${IMAGE_NAME}"
            echo "Version:   ${APPVERSION}"
            echo "Container: ${CONTAINER_NAME}"
            echo "======================================"
        }

        failure {
            echo "Laravel deployment failed."
        }

        always {
            echo "Tearing down Jenkins workspace..."
            cleanWs()
        }
    }
}
