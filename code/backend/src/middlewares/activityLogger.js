const asyncHandler = require('express-async-handler');
const prisma = require('../utils/prisma'); // ดึงมาจากไฟล์ที่ใช้เชื่อมต่อ Database

const activityLogger = asyncHandler(async (req, res, next) => {
    // ดักฟังเหตุการณ์ 'finish' คือเมื่อ API ส่งข้อมูลกลับหา User สำเร็จแล้ว
    res.on('finish', async () => {
        try {
            // เก็บข้อมูลตามความต้องการของ Admin และข้อกำหนดทางกฎหมาย
            const logData = {
               user: req.user ? req.user.sub : '-', // ข้อมูล sub จาก jwt
               method: req.method,                  // GET, POST, DELETE
               endpoint: req.originalUrl,           // เช่น /api/bookings/me
                status: res.statusCode,              // 200, 401, 400
                userAgent: req.headers['user-agent'] || null,
                ip: req.headers['x-forwarded-for'] || req.socket.remoteAddress,
            };
            //console.log(`[Activity Log] User: ${req.user ? req.user.sub : '-'} | Method: ${req.method} | Endpoint: ${req.originalUrl} | Status: ${res.statusCode} | IP: ${logData.ip} | UserAgent: ${req.headers['user-agent'] || null}`);
            // บันทึกลงตาราง ActivityLog ใน Database
           await prisma.activityLog.create({
                data: logData
            });

        } catch (error) {
            // ป้องกัน Error จากการเก็บ Log ไปขัดขวางการทำงานของระบบหลัก
            console.error('Error recording activity log:', error);
        }
    });

    next();
});

module.exports = activityLogger;