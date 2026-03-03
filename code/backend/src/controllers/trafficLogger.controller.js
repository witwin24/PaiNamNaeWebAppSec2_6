const asyncHandler = require('express-async-handler');
const trafficLogService = require('../services/trafficLogger.service');
const crypto = require('crypto');

const getTrafficLogs = asyncHandler(async (req, res) => {
    const { startDate, endDate, userId, method, statusCode, page, limit } = req.query;

    const result = await trafficLogService.getTrafficLogs({
        startDate,
        endDate,
        userId,
        method,
        statusCode,
        page,
        limit,
    });

    res.status(200).json({
        success: true,
        ...result,
    });
});

const EXPORT_SECRET = process.env.EXPORT_SECRET || 'super-secret-key';

// สร้าง key 32 bytes
const getKey = () => crypto.createHash('sha256').update(EXPORT_SECRET).digest();

const exportTrafficLogs = asyncHandler(async (req, res) => {
    if (req.user.role !== 'ADMIN') {
        return res.status(403).json({ message: 'Forbidden' });
    }

    const { startDate, endDate, userId, method, statusCode } = req.query;

    const logs = await trafficLogService.getTrafficLogs({
        startDate,
        endDate,
        userId,
        method,
        statusCode,
        page: 1,
        limit: 1000000,
    });

    const jsonData = JSON.stringify(logs.data || logs, null, 2);

    // encrypt
    const iv = crypto.randomBytes(12);
    const key = getKey();

    const cipher = crypto.createCipheriv('aes-256-gcm', key, iv);

    const encrypted = Buffer.concat([
        cipher.update(jsonData, 'utf8'),
        cipher.final(),
    ]);

    const authTag = cipher.getAuthTag();

    // รวม buffer
    const finalBuffer = Buffer.concat([iv, authTag, encrypted]);

    // แปลงเป็น base64
    const base64Data = finalBuffer.toString('base64');

    // ส่งเป็น JSON
    res.json({
        fileName: `traffic_logs_${Date.now()}.enc`,
        data: base64Data,
    });
});

module.exports = { getTrafficLogs, exportTrafficLogs };