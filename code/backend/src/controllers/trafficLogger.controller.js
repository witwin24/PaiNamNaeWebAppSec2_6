const asyncHandler = require('express-async-handler');
const trafficLogService = require('../services/trafficLogger.service');

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

module.exports = { getTrafficLogs };