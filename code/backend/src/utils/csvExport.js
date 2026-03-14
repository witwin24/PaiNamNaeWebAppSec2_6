const path = require('path');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;
const fs = require('fs');
const { Readable } = require('stream');

/**
 * Generate CSV data for user as buffer
 * @param {Object} user - User data object
 * @returns {Object} - { success: boolean, data: Buffer }
 */
const generateUserDataCSV = async (user) => {
    try {
        // Create CSV header
        let csvContent = 'Field,Value\n';

        // Prepare data rows
        const data = [
            { field: 'User ID', value: user.id || 'N/A' },
            { field: 'Username', value: user.username || 'N/A' },
            { field: 'Email', value: user.email || 'N/A' },
            { field: 'First Name', value: user.firstName || 'N/A' },
            { field: 'Last Name', value: user.lastName || 'N/A' },
            { field: 'Gender', value: user.gender || 'N/A' },
            { field: 'Phone Number', value: user.phoneNumber ? String(user.phoneNumber) : 'N/A' },
            { field: 'National ID Number', value: user.nationalIdNumber ? `'${user.nationalIdNumber}` : 'N/A' },
            { field: 'National ID Expiry Date', value: user.nationalIdExpiryDate ? new Date(user.nationalIdExpiryDate).toISOString().split('T')[0] : 'N/A' },
            { field: 'Role', value: user.role || 'PASSENGER' },
            { field: 'Is Verified', value: user.isVerified ? 'Yes' : 'No' },
            { field: 'Is Active', value: user.isActive ? 'Yes' : 'No' },
            { field: 'Created At', value: user.createdAt ? new Date(user.createdAt).toISOString() : 'N/A' },
            { field: 'Updated At', value: user.updatedAt ? new Date(user.updatedAt).toISOString() : 'N/A' },
            { field: 'Last Login', value: user.lastLogin ? new Date(user.lastLogin).toISOString() : 'N/A' }
        ];

        // Convert to CSV (with proper escaping)
        data.forEach(row => {
            const escapedValue = String(row.value).includes(',') || String(row.value).includes('"') 
                ? `"${String(row.value).replace(/"/g, '""')}"` 
                : row.value;
            csvContent += `"${row.field}","${escapedValue}"\n`;
        });

        // Add BOM for UTF-8 encoding
        const buffer = Buffer.from('\ufeff' + csvContent, 'utf8');

        return {
            success: true,
            data: buffer,
            fileName: 'user_data.csv'
        };

    } catch (error) {
        console.error('[User Data CSV Generation Error]', error);
        return {
            success: false,
            error: error.message
        };
    }
};

/**
 * Generate Driver Verification CSV data as buffer
 * @param {Object} driverVerification - Driver verification data
 * @returns {Object} - { success: boolean, data: Buffer }
 */
const generateDriverVerificationCSV = async (driverVerification) => {
    try {
        let csvContent = 'Field,Value\n';

        const data = [
            { field: 'License Number', value: driverVerification?.licenseNumber ? `'${driverVerification.licenseNumber}` : 'N/A' },
            { field: 'First Name on License', value: driverVerification?.firstNameOnLicense || 'N/A' },
            { field: 'Last Name on License', value: driverVerification?.lastNameOnLicense || 'N/A' },
            { field: 'License Type', value: driverVerification?.typeOnLicense || 'N/A' },
            { field: 'License Issue Date', value: driverVerification?.licenseIssueDate ? new Date(driverVerification.licenseIssueDate).toISOString().split('T')[0] : 'N/A' },
            { field: 'License Expiry Date', value: driverVerification?.licenseExpiryDate ? new Date(driverVerification.licenseExpiryDate).toISOString().split('T')[0] : 'N/A' },
            { field: 'Verification Status', value: driverVerification?.status || 'N/A' },
            { field: 'Created At', value: driverVerification?.createdAt ? new Date(driverVerification.createdAt).toISOString() : 'N/A' }
        ];

        data.forEach(row => {
            const escapedValue = String(row.value).includes(',') || String(row.value).includes('"') 
                ? `"${String(row.value).replace(/"/g, '""')}"` 
                : row.value;
            csvContent += `"${row.field}","${escapedValue}"\n`;
        });

        const buffer = Buffer.from('\ufeff' + csvContent, 'utf8');

        return {
            success: true,
            data: buffer,
            fileName: 'driver_verification.csv'
        };

    } catch (error) {
        console.error('[Driver Verification CSV Generation Error]', error);
        return {
            success: false,
            error: error.message
        };
    }
};

/**
 * Generate vehicles data as CSV buffer
 * @param {Array} vehicles - Array of vehicle objects
 * @returns {Object} - { success: boolean, data: Buffer }
 */
const generateVehiclesDataCSV = async (vehicles) => {
    try {
        let csvContent = 'No.,Vehicle Model,License Plate,Vehicle Type,Color,Seat Capacity,Amenities\n';

        vehicles.forEach((vehicle, index) => {
            const row = {
                no: index + 1,
                model: vehicle.vehicleModel || 'N/A',
                plate: vehicle.licensePlate ? `'${vehicle.licensePlate}` : 'N/A',
                type: vehicle.vehicleType || 'N/A',
                color: vehicle.color || 'N/A',
                capacity: String(vehicle.seatCapacity || 'N/A'),
                amenities: Array.isArray(vehicle.amenities) ? vehicle.amenities.join('; ') : 'N/A'
            };

            const values = [row.no, row.model, row.plate, row.type, row.color, row.capacity, row.amenities];
            const csvRow = values.map(val => {
                const str = String(val);
                return str.includes(',') || str.includes('"') 
                    ? `"${str.replace(/"/g, '""')}"` 
                    : `"${str}"`;
            }).join(',');

            csvContent += csvRow + '\n';
        });

        const buffer = Buffer.from('\ufeff' + csvContent, 'utf8');

        return {
            success: true,
            data: buffer,
            fileName: 'vehicles_data.csv'
        };

    } catch (error) {
        console.error('[Vehicles CSV Generation Error]', error);
        return {
            success: false,
            error: error.message
        };
    }
};

module.exports = {
    generateUserDataCSV,
    generateDriverVerificationCSV,
    generateVehiclesDataCSV
};
