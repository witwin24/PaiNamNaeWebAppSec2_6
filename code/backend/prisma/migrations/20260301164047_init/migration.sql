/*
  Warnings:

  - You are about to drop the `UserArchive` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "UserArchive";

-- CreateTable
CREATE TABLE "TrafficLog" (
    "id" SERIAL NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "sourceIp" TEXT NOT NULL,
    "sourcePort" TEXT NOT NULL,
    "destinationUrl" TEXT NOT NULL,
    "destinationPort" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "userAgent" TEXT,
    "method" TEXT NOT NULL,
    "protocol" TEXT NOT NULL,
    "statusCode" INTEGER NOT NULL,
    "action" TEXT NOT NULL,

    CONSTRAINT "TrafficLog_pkey" PRIMARY KEY ("id")
);
