const axios = require('axios');

const escapeHtml = (value = '') => String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');

const getEmailConfig = () => {
    const {
        EMAIL_PROVIDER,
        RESEND_API_KEY,
        RESEND_API_URL,
        EMAIL_FROM,
        EMAIL_FROM_NAME
    } = process.env;

    const provider = (EMAIL_PROVIDER || 'resend').toLowerCase();

    if (provider !== 'resend') {
        return {
            valid: false,
            message: 'Unsupported email provider. Set EMAIL_PROVIDER=resend.'
        };
    }

    if (!RESEND_API_KEY) {
        return {
            valid: false,
            message: 'Email API key is missing. Set RESEND_API_KEY.'
        };
    }

    return {
        valid: true,
        provider,
        apiKey: RESEND_API_KEY,
        apiUrl: RESEND_API_URL || 'https://api.resend.com/emails',
        from: EMAIL_FROM,
        fromName: EMAIL_FROM_NAME || 'PaiNamNae Support Team'
    };
};

const sendWithResend = async ({ recipientEmail, zipBuffer, safeUserName, emailConfig }) => {
    if (!emailConfig.from) {
        throw new Error('Email sender is missing. Set EMAIL_FROM to a verified Resend sender.');
    }

    const payload = {
        from: `${emailConfig.fromName} <${emailConfig.from}>`,
        to: [recipientEmail],
        subject: 'Your Account Data Export - PaiNamNae',
        html: `
            <h2>Account Data Export</h2>
            <p>Dear ${safeUserName},</p>
            <p>As requested, your account data has been exported and compressed into a zip file.</p>

            <h3>File Details:</h3>
            <ul>
                <li><strong>File Name:</strong> user_data_export.zip</li>
                <li><strong>Contents:</strong> Personal data and account records as selected during your account deletion process.</li>
            </ul>

            <h3>How to Extract:</h3>
            <ol>
                <li>Download the attached zip file</li>
                <li>Extract the files on your computer using any zip extraction tool</li>
            </ol>

            <p><strong>Note:</strong> This is an automated email. Your account has been deleted, and this export file is for your records.</p>

            <p>Best regards,<br>PaiNamNae Support Team</p>
        `,
        attachments: [
            {
                filename: 'user_data_export.zip',
                content: zipBuffer.toString('base64')
            }
        ]
    };

    const response = await axios.post(emailConfig.apiUrl, payload, {
        headers: {
            Authorization: `Bearer ${emailConfig.apiKey}`,
            'Content-Type': 'application/json'
        },
        timeout: 15000
    });

    return response.data;
};

/**
 * Send exported user data zip file via email
 * @param {string} recipientEmail - Recipient email address
 * @param {Buffer} zipBuffer - Zip file data as buffer
 * @param {string} userName - User name for personalization
 * @returns {Object} - { success: boolean, message: string }
 */
const sendExportedDataEmail = async (recipientEmail, zipBuffer, userName) => {
    try {
        const emailConfig = getEmailConfig();

        if (!emailConfig.valid) {
            console.warn('[Email Service]', emailConfig.message);
            return {
                success: false,
                message: emailConfig.message
            };
        }

        // Check if zip buffer exists
        if (!zipBuffer || zipBuffer.length === 0) {
            throw new Error('Zip file data is empty');
        }

        const safeUserName = escapeHtml(userName || 'User');

        const info = await sendWithResend({
            recipientEmail,
            zipBuffer,
            safeUserName,
            emailConfig
        });
        
        console.log('[Email] Sent to:', recipientEmail, 'Message ID:', info.id);

        return {
            success: true,
            message: 'Export data sent to email successfully',
            messageId: info.id
        };

    } catch (error) {
        const responseError = error.response?.data;
        console.error('[Email Service Error]', responseError || error);
        return {
            success: false,
            message: responseError?.message || error.message || 'Failed to send email'
        };
    }
};

module.exports = {
    sendExportedDataEmail
};
