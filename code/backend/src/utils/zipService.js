const archiver = require('archiver');
const { PassThrough } = require('stream');

/**
 * Create a password-protected zip file from CSV buffers
 * @param {Array} csvFiles - Array of objects with { fileName: string, data: Buffer }
 * @param {string} password - Password for encryption (National ID Number)
 * @returns {Object} - { success: boolean, data: Buffer }
 */
const createPasswordProtectedZip = async (csvFiles, password) => {
    try {
        const archive = archiver('zip', {
            zlib: { level: 9 } // Maximum compression
        });

        const chunks = [];
        const passThrough = new PassThrough();

        return new Promise((resolve, reject) => {
            passThrough.on('data', (chunk) => {
                chunks.push(chunk);
            });

            passThrough.on('end', () => {
                const buffer = Buffer.concat(chunks);
                console.log('[Zip] Zip buffer created successfully, size:', buffer.length, 'bytes');
                
                resolve({
                    success: true,
                    data: buffer
                });
            });

            passThrough.on('error', reject);
            archive.on('error', reject);

            archive.pipe(passThrough);

            // Add CSV files to archive
            for (const csvFile of csvFiles) {
                archive.append(csvFile.data, { name: csvFile.fileName });
            }

            archive.finalize();
        });

    } catch (error) {
        console.error('[Zip Service Error]', error);
        return {
            success: false,
            error: error.message
        };
    }
};

/**
 * Generate password from date of birth in format DDMMYYYY
 * @param {Date} dateOfBirth - Date of birth
 * @returns {string} - Password in format DDMMYYYY
 */
const generatePasswordFromDOB = (dateOfBirth) => {
    try {
        const date = new Date(dateOfBirth);
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        
        return `${day}${month}${year}`;
    } catch (error) {
        console.error('[DOB Password Generation Error]', error);
        throw new Error('Invalid date of birth');
    }
};

module.exports = {
    createPasswordProtectedZip
};
