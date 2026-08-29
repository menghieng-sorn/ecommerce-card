-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20260814.7ff5dd5b7e
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 29, 2026 at 11:10 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommerce_card_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--
CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--
CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--
CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_08_13_184112_create_products_table', 1),
(5, '2026_08_17_203454_create_product_images_table', 1),
(6, '2026_08_17_203501_create_product_colors_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--
CREATE TABLE `products` (
  `id` bigint UNSIGNED NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` double NOT NULL,
  `short_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int NOT NULL DEFAULT '0',
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `image`, `name`, `price`, `short_description`, `qty`, `sku`, `description`, `created_at`, `updated_at`) VALUES
(2, 'uploads/9ntaYQ3CBdS7gR3KsLiVu8SluCCkMpqFmeaNuK8q.webp', 'ABEX SAPPHIRE RZ15', 249, 'The Sapphire RZ15 is an affordable, high-performance laptop with a fast Ryzen 7 processor', 11, 'Sku', '<p>The Sapphire RZ15 is an affordable, high-performance laptop with a fast Ryzen 7 processor, a lightweight half-aluminum chassis for durability and portability, and efficient heat dissipation. Its slim, premium design features a 15-inch full HD IPS display, delivering excellent visuals and reliable performance for creative professionals and tech enthusiasts.</p>', '2026-08-21 08:20:08', '2026-08-21 08:20:08'),
(3, 'uploads/vq52ve9QG6iJZkEcDk68MjvQ30kwJ1Ooo8z58mdc.jpg', 'ABEX TOUCH M15S', 949, 'Crafted with a 15-inch display, featuring 10 point multi-touch technology,', 16, 'Sku', '<p>Crafted with a 15-inch display, featuring 10 point multi-touch technology, M15S delivers rapid performance and seamless multitasking capabilities.</p>\r\n<p>Artfully engineered with a more compact design, M15S showcases a slender profile and premium build quality that radiates sophistication without compromising affordability. Whether you&rsquo;re a creative professional or a tech-savvy individual, the M15S is poised to make a bold statement.</p>', '2026-08-21 08:21:13', '2026-08-21 08:21:13'),
(4, 'uploads/w4tIDLHzQKSfPNFPTjqwBAmb30wrvuw2IeKlwQYX.jpg', 'ABEX ZENITH GT13', 588, 'Introducing the Zenith GT13, a high-performance gaming', 6, 'Sku', '<p>Introducing the Zenith GT13, a high-performance gaming and productivity laptop equipped with a powerful Intel Core i9 processor, NVIDIA GeForce RTX 4050 graphics card, advanced cooling system, and a customizable RGB keyboard. Designed for speed, power, and breathtaking visuals, it delivers an unmatched gaming experience with a vibrant 16-inch FHD IPS display and a smooth 144Hz refresh rate.</p>', '2026-08-21 08:24:06', '2026-08-21 08:24:06'),
(5, 'uploads/SqZP7Wfj3QJIvN9DRfqSW1IipoVpt5f26WDWzL2h.jpg', 'ABEX ZENUM 7 PLUS', 688, 'Introducing the ZENUM 7 PLUS, the ultimate gaming laptop built with a high-end Intel i7 processor', 12, 'Sku', '<p>Introducing the ZENUM 7 PLUS, the ultimate gaming laptop built with a high-end Intel i7 processor with max frequency of 4.90GHz and Nvidia GeForce RTX 4060 Graphics Card, designed to deliver an unparalleled gaming experience with power, speed, and immersive visuals.</p>\r\n<p>ZENUM employs an advanced cooling system with multiple high-performance fans and efficient heat dissipation technology, ensuring your laptop remains cool and performs optimally even during extended gaming marathons. It also features a responsive and adjustable RGB keyboard ambience.</p>\r\n<p>A fusion of power, portability, and style &ndash; is the perfect companion for any avid gamer. Elevate your gaming experience and conquer virtual worlds like never before. Level up with the ABEX ZENUM today!</p>', '2026-08-21 12:53:21', '2026-08-21 12:53:21');

-- --------------------------------------------------------

--
-- Table structure for table `product_colors`
--
CREATE TABLE `product_colors` (
  `id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_colors`
--

INSERT INTO `product_colors` (`id`, `product_id`, `name`, `created_at`, `updated_at`) VALUES
(9, 2, 'black', '2026-08-21 08:20:08', '2026-08-21 08:20:08'),
(10, 2, 'green', '2026-08-21 08:20:08', '2026-08-21 08:20:08'),
(11, 3, 'black', '2026-08-21 08:21:13', '2026-08-21 08:21:13'),
(12, 4, 'black', '2026-08-21 08:24:06', '2026-08-21 08:24:06'),
(13, 5, 'red', '2026-08-21 12:53:21', '2026-08-21 12:53:21');

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--
CREATE TABLE `product_images` (
  `id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `path`, `created_at`, `updated_at`) VALUES
(7, 2, 'uploads/eN3ZJ83DsXbn9Ej06euK6R8MmGBN2Q6QuQB8d4SJ.jpg', '2026-08-21 08:20:08', '2026-08-21 08:20:08'),
(8, 2, 'uploads/NOnMVK2KDdFghqN7HtU9AMSYpPvm1ZoRiSbXaFUf.jpg', '2026-08-21 08:20:09', '2026-08-21 08:20:09'),
(9, 2, 'uploads/QwGfhoCz4qp1B9ANeZMmsrezs8gjiJDveXG4ukf2.jpg', '2026-08-21 08:20:09', '2026-08-21 08:20:09'),
(10, 2, 'uploads/K6B9vvp28ABms7qdeNkAMv0cJ9IzIAXQpOTEp88Y.jpg', '2026-08-21 08:20:09', '2026-08-21 08:20:09'),
(11, 3, 'uploads/RZTUH6ClVi3nFkR8anh8jbrdh1saD2PqTOhDMxMH.jpg', '2026-08-21 08:21:13', '2026-08-21 08:21:13'),
(12, 3, 'uploads/OeUCg9U3TKvj63EqTrcG6lUk5ZM14mkx4PRfATEd.webp', '2026-08-21 08:21:13', '2026-08-21 08:21:13'),
(13, 3, 'uploads/NIlkHaVNHpkNQeidTpsQYjX6XhJ5w15RtQz8qkY6.jpg', '2026-08-21 08:21:13', '2026-08-21 08:21:13'),
(14, 3, 'uploads/04QN87G7OJA4dmImwkO3BinKyofpAeSVxNxyzCXN.jpg', '2026-08-21 08:21:13', '2026-08-21 08:21:13'),
(15, 3, 'uploads/aGMF3r5BgeFPBptTBFGhgINZAy4jZhKKM8EyFvw7.jpg', '2026-08-21 08:21:13', '2026-08-21 08:21:13'),
(16, 4, 'uploads/V9r8vLkf2h2f7fIwN7q87r3OrqlG98ZXVJu5qct1.jpg', '2026-08-21 08:24:06', '2026-08-21 08:24:06'),
(17, 4, 'uploads/q3mOGcw1OBH1ztJtdtDByuU0l3qKjTceEq0ifU2Q.jpg', '2026-08-21 08:24:06', '2026-08-21 08:24:06'),
(18, 4, 'uploads/k7aAE8B9VOOBPiNFk45FHqrSZRjziAe0ORSfaKgz.jpg', '2026-08-21 08:24:06', '2026-08-21 08:24:06'),
(19, 4, 'uploads/0vxaTTT8a3tVHMDCkxpySBC7pgya0b495xIVpY9E.jpg', '2026-08-21 08:24:06', '2026-08-21 08:24:06'),
(20, 5, 'uploads/x2gbjQtAisUbCOflMrBAUjmr2omdDkwpWK3qrymR.jpg', '2026-08-21 12:53:21', '2026-08-21 12:53:21'),
(21, 5, 'uploads/PegDX0sGPjQPyEAxyVDlgopD8wXg9nOubScgXAuj.jpg', '2026-08-21 12:53:21', '2026-08-21 12:53:21'),
(22, 5, 'uploads/2BjLbNXzvHp205OGxfj3RJuiaRBaH9VIXotcBI85.jpg', '2026-08-21 12:53:21', '2026-08-21 12:53:21');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('arD48PuQCGANgJRkpv7kVQMxpt1xHH92DvsKvc3o', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:154.0) Gecko/20100101 Firefox/154.0', 'YTo0OntzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3Byb2R1Y3QtZGV0YWlsLzMiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjY6Il90b2tlbiI7czo0MDoiSHdOd2ZWempTNmJuZEEwY2VnNVpzTHhuT20yRGJ1azBxYnQ5Ynd1aCI7czo0OiJjYXJ0IjthOjI6e2k6MzthOjY6e3M6MjoiaWQiO3M6MToiMyI7czo1OiJpbWFnZSI7TjtzOjQ6Im5hbWUiO047czo1OiJwcmljZSI7TjtzOjU6ImNvbG9yIjtzOjM6InJlZCI7czozOiJxdHkiO2k6MTt9aToyO2E6Njp7czoyOiJpZCI7czoxOiIyIjtzOjU6ImltYWdlIjtOO3M6NDoibmFtZSI7TjtzOjU6InByaWNlIjtOO3M6NToiY29sb3IiO3M6MzoicmVkIjtzOjM6InF0eSI7aToxO319fQ==', 1787587502),
('SWSiXr0banLXYAaLK5dbkp39z0tq9wV3SiyLLaAn', NULL, '127.0.0.1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiZTFWNnlWT05BbmdSVW9Mc3lwdUdsTHF0YWkzcmtXR0lUcm96N1RhaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzg6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wcm9kdWN0LWRldGFpbC8yIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo0OiJjYXJ0IjthOjY6e3M6MjoiaWQiO3M6MToiMiI7czo1OiJpbWFnZSI7TjtzOjQ6Im5hbWUiO047czo1OiJwcmljZSI7TjtzOjU6ImNvbG9yIjtzOjM6InJlZCI7czozOiJxdHkiO2k6MTt9fQ==', 1787581840);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--
CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(20, 'Admin', 'admin@gmail.com', NULL, '$2y$12$h8LFEL1BaV9I6lvkMUnlcuV9Hilf.0.9ZLAvTp3fqWbtfgSBFcYhm', NULL, '2026-08-21 06:21:56', '2026-08-21 06:21:56');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product_colors`
--
ALTER TABLE `product_colors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_colors_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_images_product_id_foreign` (`product_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `product_colors`
--
ALTER TABLE `product_colors`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `product_colors`
--
ALTER TABLE `product_colors`
  ADD CONSTRAINT `product_colors_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
