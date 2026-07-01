-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 01, 2026 at 05:00 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `univelo_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `complaints`
--

CREATE TABLE `complaints` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `complaint_type` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `resolution` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `complaints`
--

INSERT INTO `complaints` (`id`, `user_id`, `complaint_type`, `description`, `status`, `resolution`, `created_at`) VALUES
(1, 3, 'Billing Discrepancy', 'Driver named fatihah charged me more than 4 ringgit', 'RESOLVED', 'We have contacted the driver about this issue, we are apologized from our behalf, we will contact you back and refund the extra money', '2026-06-29 20:04:28'),
(2, 3, 'App System Glitch', 'why my app got stuck when the driver set the ride as complete ?', 'RESOLVED', 'sorry for the trouble that we caused, we will fix the problem as soon as possible', '2026-06-29 20:26:51'),
(3, 4, 'Passenger Misbehavior', 'Passenger named izwan is sexual harrasing me', 'RESOLVED', 'we take this as a serious matter, we will take a serious action towards the passenger, we are truly sorry for the trouble', '2026-06-30 05:11:35'),
(4, 3, 'Other', 'teggs', 'RESOLVED', 'gdghsge', '2026-06-30 09:46:00'),
(5, 4, 'Payment Dispute', 'The passenger named izwan dont pay and run away', 'RESOLVED', 'We are sorry for the passenger misbehavior, we will make sure the passenger pay the money as soon as possible', '2026-07-01 01:50:08');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `is_read`, `created_at`) VALUES
(1, 3, '⚠️ Complaint Resolved', 'Your Other complaint (#4) has been resolved by Admin: \"gdghsge\"', 1, '2026-06-30 09:46:14'),
(2, 4, '⚠️ Complaint Resolved', 'Your Passenger Misbehavior complaint (#3) has been resolved by Admin: \"we take this as a serious matter, we will take a serious action towards the passenger, we are truly sorry for the trouble\"', 1, '2026-06-30 09:52:22'),
(3, 4, '🏁 Ride Completed Successfully', 'Trip #6 to kolej delima 1 has been successfully finalized. Collect your fare!', 1, '2026-06-30 10:01:54'),
(4, 4, '🏁 Ride Completed Successfully', 'Trip #7 to datc has been successfully finalized. Collect your fare!', 1, '2026-06-30 10:05:42'),
(5, 4, '🏁 Ride Completed Successfully', 'Trip #8 to kolej delima 1 has been successfully finalized. Collect your fare!', 1, '2026-06-30 10:13:22'),
(7, 4, '🏁 Ride Completed Successfully', 'Trip #9 to dc has been successfully finalized.', 1, '2026-06-30 10:20:28'),
(8, 3, '✅ Your Ride is Complete!', 'Your trip with driver fatihah has arrived safely. Thank you for using UniVelo!', 1, '2026-06-30 10:20:28'),
(9, 4, '⚠️ Complaint Resolved', 'Your Payment Dispute complaint (#5) has been resolved by Admin: \"We are sorry for the passenger misbehavior, we will make sure the passenger pay the money as soon as possible\"', 1, '2026-07-01 01:51:39'),
(10, 4, '🏁 Ride Completed Successfully', 'Trip #10 to pb uitm has been successfully finalized.', 0, '2026-07-01 02:03:52'),
(11, 3, '✅ Your Ride is Complete!', 'Your trip with driver fatihah has arrived safely. Thank you for using UniVelo!', 1, '2026-07-01 02:03:52'),
(12, 4, '🏁 Ride Completed Successfully', 'Trip #11 to pusat sukan has been successfully finalized.', 0, '2026-07-01 02:06:42'),
(13, 3, '✅ Your Ride is Complete!', 'Your trip with driver fatihah has arrived safely. Thank you for using UniVelo!', 1, '2026-07-01 02:06:42'),
(14, 4, '🏁 Ride Completed Successfully', 'Trip #12 to pusat sukan has been successfully finalized.', 0, '2026-07-01 02:36:58'),
(15, 3, '✅ Your Ride is Complete!', 'Your trip with driver fatihah has arrived safely. Thank you for using UniVelo!', 0, '2026-07-01 02:36:58'),
(16, 4, '🏁 Ride Completed Successfully', 'Trip #13 to pk has been successfully finalized.', 0, '2026-07-01 02:39:15'),
(17, 3, '✅ Your Ride is Complete!', 'Your trip with driver fatihah has arrived safely. Thank you for using UniVelo!', 0, '2026-07-01 02:39:15');

-- --------------------------------------------------------

--
-- Table structure for table `rides`
--

CREATE TABLE `rides` (
  `id` int(11) NOT NULL,
  `passenger_id` int(11) NOT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `pickup_location` varchar(255) NOT NULL,
  `dropoff_location` varchar(255) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `car_model` varchar(100) DEFAULT NULL,
  `car_color` varchar(50) DEFAULT NULL,
  `number_plate` varchar(50) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rides`
--

INSERT INTO `rides` (`id`, `passenger_id`, `driver_id`, `pickup_location`, `dropoff_location`, `price`, `car_model`, `car_color`, `number_plate`, `status`, `created_at`) VALUES
(1, 3, 4, 'fskm', 'datc', 6.00, 'Perodua Axia', 'Red', 'BNU1257', 'COMPLETED', '2026-06-28 20:08:35'),
(2, 3, 4, 'fsg', 'dc', 5.00, 'Perodua Axia', 'Red', 'BNU1257', 'COMPLETED', '2026-06-28 21:03:19'),
(4, 3, 4, 'fskm', 'pusat sukan', 7.00, 'Perodua Axia', 'Red', 'BNU1257', 'COMPLETED', '2026-06-30 04:59:10'),
(5, 3, 4, 'kolej seroja', 'kolej delima 1', 4.50, 'Perodua Axia', 'Red', 'BNU1257', 'COMPLETED', '2026-06-30 09:53:38'),
(6, 3, 4, 'fsg', 'kolej delima 1', 7.00, 'Perodua Axia', 'Red', 'BNU1257', 'COMPLETED', '2026-06-30 10:01:35'),
(7, 3, 4, 'kolej seroja', 'datc', 5.00, 'Perodua Axia', 'Red', 'BNU1257', 'COMPLETED', '2026-06-30 10:04:54'),
(8, 3, 4, 'fskm', 'kolej delima 1', 6.00, 'Perodua Axia', 'Red', 'BNU1257', 'COMPLETED', '2026-06-30 10:12:47'),
(9, 3, 4, 'kolej seroja', 'dc', 5.00, 'Perodua Axia', 'Red', 'BNU1257', 'COMPLETED', '2026-06-30 10:19:41'),
(10, 3, 4, 'terminal lrt uitm shah alam', 'pb uitm', 5.00, 'Proton S70', 'Black', 'WUF2257', 'COMPLETED', '2026-07-01 01:53:48'),
(11, 3, 4, 'fsg', 'pusat sukan', 7.00, 'Proton Saga', 'Grey', 'BNU 1257', 'COMPLETED', '2026-07-01 02:04:17'),
(12, 3, 4, 'fskm', 'pusat sukan', 3.00, 'Proton Saga', 'Grey', 'BNU1257', 'COMPLETED', '2026-07-01 02:19:36'),
(13, 3, 4, 'miku', 'pk', 3.00, 'Honda Civic', 'White', 'CBU 1434', 'COMPLETED', '2026-07-01 02:37:30');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `role` varchar(20) NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `document_path` varchar(255) DEFAULT NULL,
  `profile_pic_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `phone`, `role`, `status`, `document_path`, `profile_pic_path`) VALUES
(2, 'admin', 'admin123', '0000000000', 'ADMIN', 'APPROVED', NULL, NULL),
(3, 'izwan', 'izwan123', '01127240294', 'PASSENGER', 'APPROVED', 'uploads/1782677220118_passport.jpg', 'uploads/1782822902798_passport.jpg'),
(4, 'fatihah', 'fat123', '0136675243', 'DRIVER', 'APPROVED', 'uploads/1782677242557_WhatsApp Image 2026-06-22 at 4.44.31 AM (1).jpeg', 'uploads/1782795538336_WhatsApp Image 2026-06-22 at 4.44.31 AM (1).jpeg'),
(5, 'bawan', 'bawan123', '0176548875', 'PASSENGER', 'PENDING', 'uploads/1782682274725_Screenshot 2024-07-05 164538.png', NULL),
(6, 'aqilah', 'qela123', '0149965245', 'PASSENGER', 'REJECTED', 'uploads/1782788856833_Screenshot 2024-07-05 164538.png', NULL),
(7, 'vivian', 'vivi123', '01169883325', 'DRIVER', 'APPROVED', 'uploads/1782822234413_WhatsApp Image 2026-06-22 at 4.44.31 AM (1).jpeg', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `complaints`
--
ALTER TABLE `complaints`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_complaints_user` (`user_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `rides`
--
ALTER TABLE `rides`
  ADD PRIMARY KEY (`id`),
  ADD KEY `passenger_id` (`passenger_id`),
  ADD KEY `driver_id` (`driver_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `complaints`
--
ALTER TABLE `complaints`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `rides`
--
ALTER TABLE `rides`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `complaints`
--
ALTER TABLE `complaints`
  ADD CONSTRAINT `fk_complaints_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rides`
--
ALTER TABLE `rides`
  ADD CONSTRAINT `rides_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `rides_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
