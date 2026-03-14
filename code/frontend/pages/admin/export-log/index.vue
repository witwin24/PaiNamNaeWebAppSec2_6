<template>
    <div class="">
        <AdminHeader />
        <AdminSidebar />

        <!-- Main Content -->
        <main id="main-content" class="main-content mt-16 ml-0 lg:ml-[280px] p-6">
            <!-- Page Title -->
            <div class="mx-auto max-w-8xl">
                <!-- Title -->
                <div class="flex flex-col gap-3 mb-6 sm:flex-row sm:items-center sm:justify-between">
                    <h1 class="text-2xl font-semibold text-gray-800">Export Log</h1>
                </div>

                <!-- Advanced Filters -->
                <div class="mb-4 bg-white border border-gray-300 rounded-lg shadow-sm">
                    <div class="grid grid-cols-1 gap-3 px-4 py-4 sm:px-6 lg:grid-cols-[repeat(24,minmax(0,1fr))]">

                        <!-- Start Date (5/24) -->
                        <div class="lg:col-span-5">
                            <label class="block mb-1 text-xs font-medium text-gray-600">วันที่เริ่มต้น</label>
                            <input v-model="filters.startDate" type="datetime-local" id="startDate"
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500" />
                        </div>

                        <!-- End Date (5/24) -->
                        <div class="lg:col-span-5">
                            <label class="block mb-1 text-xs font-medium text-gray-600">วันที่สิ้นสุด</label>
                            <input v-model="filters.endDate" type="datetime-local" id="endDate"
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500" />
                        </div>

                        <!-- Actions -->
                        <div class="flex items-end justify-end gap-2 mt-1 lg:col-span-14 lg:mt-0">
                            <button @click="clearFilters"
                                class="px-3 py-2 text-gray-700 border border-gray-300 rounded-md cursor-pointer hover:bg-gray-50" id="clearFilters">
                                ล้างตัวกรอง
                            </button>
                            <button @click="applyFilters"
                               class="px-4 py-2 text-white bg-blue-600 rounded-md cursor-pointer hover:bg-blue-700" id="applyFilters">
                                ใช้ตัวกรอง
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Card -->
                <div class="bg-white border border-gray-300 rounded-lg shadow-sm">
                    <div class="flex items-center justify-between px-4 py-4 border-b border-gray-200 sm:px-6">
                        <div class="text-sm text-gray-600">
                            หน้าที่ {{ pagination.page }} / {{ totalPages }} • ทั้งหมด {{ pagination.total }} รายการ
                        </div>
                    </div>

                    <!-- Loading / Error -->
                    <div v-if="isLoading" class="p-8 text-center text-gray-500">กำลังโหลดข้อมูล...</div>
                    <div v-else-if="loadError" class="p-8 text-center text-red-600">
                        {{ loadError }}
                    </div>

                    <!-- Table -->
                    <div v-else class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase">
                                        Admin ID
                                    </th>
                                    <th class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase">
                                        ประเภทข้อมูล
                                    </th>
                                    <th class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase">
                                        วันที่สร้าง
                                    </th>
                                    <th class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase">
                                        IP Address
                                    </th>
                                    <th class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase">
                                        รูปแบบไฟล์
                                    </th>
                                    <th class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase">
                                        รายละเอียด
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <tr v-for="log in logs" :key="log.id" class="transition-opacity hover:bg-gray-50">
                                    <td class="px-4 py-3">
                                        <span class="font-mono text-sm text-gray-700">{{ log.adminId || '-' }}</span>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-gray-700">
                                        {{ log.exportedDataType || '-' }}
                                    </td>
                                    <td class="px-4 py-3 text-sm text-gray-700 whitespace-nowrap">
                                        {{ formatDate(log.createdAt) }}
                                    </td>
                                    <td class="px-4 py-3">
                                        <span class="font-mono text-sm text-gray-700">{{ log.ipAddress || '-' }}</span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <span class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-700">
                                            {{ log.fileFormat || '-' }}
                                        </span>
                                    </td>
                                    <td class="px-4 py-3 text-center">
                                        <button @click="openDetailModal(log)"
                                            class="text-sm text-blue-600 hover:text-blue-800 hover:underline cursor-pointer" id="details">
                                            <i class="fas fa-eye"></i> ดู
                                        </button>
                                    </td>
                                </tr>

                                <tr v-if="!logs.length">
                                    <td colspan="7" class="px-4 py-10 text-center text-gray-500">
                                        ไม่มีข้อมูล Export Log
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div
                        class="flex flex-col gap-3 px-4 py-4 border-t border-gray-200 sm:px-6 sm:flex-row sm:items-center sm:justify-between">
                        <div class="flex flex-wrap items-center gap-3 text-sm">
                            <div class="flex items-center gap-2">
                                <span class="text-xs text-gray-500">Limit:</span>
                                <select v-model.number="pagination.limit" @change="applyFilters" id="limit"
                                    class="px-2 py-1 text-sm border border-gray-300 rounded-md focus:ring-blue-500">
                                    <option id="20" :value="20">20</option>
                                    <option id="50" :value="50">50</option>
                                    <option id="100" :value="100">100</option>
                                </select>
                            </div>
                        </div>

                        <nav class="flex items-center gap-1">
                            <button id="Previous" class="px-3 py-2 text-sm border rounded-md disabled:opacity-50"
                                :disabled="pagination.page <= 1 || isLoading" @click="changePage(pagination.page - 1)">
                                Previous
                            </button>

                            <template v-for="(p, idx) in pageButtons">
                                <span v-if="p === '…'" :key="`ellipsis-${idx}`" class="px-2 text-sm text-gray-500">…</span>
                                <button v-else :key="`page-${p}`" class="px-3 py-2 text-sm border rounded-md"
                                    :class="p === pagination.page ? 'bg-blue-50 text-blue-600 border-blue-200' : 'hover:bg-gray-50'"
                                    :disabled="isLoading" @click="changePage(p)">
                                    {{ p }}
                                </button>
                            </template>

                            <button id="next" class="px-3 py-2 text-sm border rounded-md disabled:opacity-50"
                                :disabled="pagination.page >= totalPages || isLoading"
                                @click="changePage(pagination.page + 1)">
                                Next
                            </button>
                        </nav>
                    </div>
                </div>
            </div>
        </main>

        <!-- Detail Modal -->
        <div v-if="showDetailModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div class="w-full max-w-2xl mx-4 bg-white rounded-lg shadow-xl">
                <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200">
                    <h2 class="text-lg font-semibold text-gray-800">รายละเอียด Export Log</h2>
                    <button @click="closeDetailModal" class="text-gray-400 hover:text-gray-600">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <div v-if="selectedLog" class="px-6 py-4 space-y-4 max-h-[60vh] overflow-y-auto">
                    <!-- Admin Information -->
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="text-xs font-medium text-gray-600">Admin ID</label>
                            <p class="text-sm text-gray-800 font-mono">{{ selectedLog.adminId }}</p>
                        </div>
                        <div>
                            <label class="text-xs font-medium text-gray-600">Admin Username</label>
                            <p class="text-sm text-gray-800">{{ selectedLog.adminUsername || '-' }}</p>
                        </div>
                        <div>
                            <label class="text-xs font-medium text-gray-600">Admin Role</label>
                            <p class="text-sm text-gray-800">
                                <span class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full bg-purple-100 text-purple-700">
                                    {{ selectedLog.adminRole }}
                                </span>
                            </p>
                        </div>
                        <div>
                            <label class="text-xs font-medium text-gray-600">IP Address</label>
                            <p class="text-sm text-gray-800 font-mono">{{ selectedLog.ipAddress }}</p>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Export Information -->
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="text-xs font-medium text-gray-600">ประเภทข้อมูล</label>
                            <p class="text-sm text-gray-800">{{ selectedLog.exportedDataType }}</p>
                        </div>
                        <div>
                            <label class="text-xs font-medium text-gray-600">รูปแบบไฟล์</label>
                            <p class="text-sm text-gray-800">
                                <span class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-700">
                                    {{ selectedLog.fileFormat }}
                                </span>
                            </p>
                        </div>
                        <div>
                            <label class="text-xs font-medium text-gray-600">จำนวนแถว</label>
                            <p class="text-sm text-gray-800">{{ selectedLog.rowCount || '-' }}</p>
                        </div>
                        <div>
                            <label class="text-xs font-medium text-gray-600">วันที่หมดอายุ</label>
                            <p class="text-sm text-gray-800">{{ formatDate(selectedLog.expiresAt) }}</p>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Scope Information -->
                    <div>
                        <label class="text-xs font-medium text-gray-600">ขอบเขตข้อมูล</label>
                        <p class="text-sm text-gray-800">{{ selectedLog.dataScope || '-' }}</p>
                    </div>

                    <!-- Security Measure -->
                    <div v-if="selectedLog.securityMeasure">
                        <label class="text-xs font-medium text-gray-600">การรักษาความปลอดภัย</label>
                        <p class="text-sm text-gray-800">{{ selectedLog.securityMeasure }}</p>
                    </div>

                    <!-- User Agent -->
                    <div>
                        <label class="text-xs font-medium text-gray-600">User Agent</label>
                        <p class="text-xs text-gray-800 font-mono break-words">{{ selectedLog.userAgent || '-' }}</p>
                    </div>

                    <!-- Timestamps -->
                    <hr class="my-4">
                    <div class="grid grid-cols-2 gap-4 text-xs">
                        <div>
                            <label class="font-medium text-gray-600">สร้างเมื่อ</label>
                            <p class="text-gray-800">{{ formatDate(selectedLog.createdAt) }}</p>
                        </div>
                        <div>
                            <label class="font-medium text-gray-600">ลบเมื่อ</label>
                            <p class="text-gray-800">{{ selectedLog.deletedAt ? formatDate(selectedLog.deletedAt) : 'ยังไม่ได้ลบ' }}</p>
                        </div>
                    </div>
                </div>

                <div class="flex justify-end gap-2 px-6 py-4 border-t border-gray-200">
                    <button @click="closeDetailModal"
                        class="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50 cursor-pointer">
                        ปิด
                    </button>
                </div>
            </div>
        </div>

        <!-- Mobile Overlay -->
        <div id="overlay" class="fixed inset-0 z-40 hidden bg-black bg-opacity-50 lg:hidden"
            @click="closeMobileSidebar"></div>
    </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import { useRuntimeConfig, useCookie } from '#app'
import dayjs from 'dayjs'
import 'dayjs/locale/th'
import utc from 'dayjs/plugin/utc'
import timezone from 'dayjs/plugin/timezone'
import buddhistEra from 'dayjs/plugin/buddhistEra'
import AdminHeader from '~/components/admin/AdminHeader.vue'
import AdminSidebar from '~/components/admin/AdminSidebar.vue'
import { useToast } from '~/composables/useToast'

dayjs.locale('th')
dayjs.extend(buddhistEra)
dayjs.extend(utc)
dayjs.extend(timezone)

definePageMeta({ middleware: ['admin-auth'] })

const { toast } = useToast()

const isLoading = ref(false)
const loadError = ref('')
const logs = ref([])
const showDetailModal = ref(false)
const selectedLog = ref(null)

const pagination = reactive({
    page: 1,
    limit: 20,
    total: 0,
    totalPages: 1
})

const filters = reactive({
    startDate: '',
    endDate: '',
    exportedDataType: ''
})

const totalPages = computed(() =>
    Math.max(1, pagination.totalPages || Math.ceil((pagination.total || 0) / (pagination.limit || 20)))
)

const pageButtons = computed(() => {
    const total = totalPages.value
    const current = pagination.page
    if (!total || total < 1) return []
    if (total <= 5) return Array.from({ length: total }, (_, i) => i + 1)
    const set = new Set([1, total, current])
    if (current - 1 > 1) set.add(current - 1)
    if (current + 1 < total) set.add(current + 1)
    const pages = Array.from(set).sort((a, b) => a - b)
    const out = []
    for (let i = 0; i < pages.length; i++) {
        if (i > 0 && pages[i] - pages[i - 1] > 1) out.push('…')
        out.push(pages[i])
    }
    return out
})

function formatDate(iso) {
    if (!iso) return '-'
    return dayjs.utc(iso).tz('Asia/Bangkok').format('D MMM BBBB HH:mm:ss')
}

async function fetchLogs(page = 1) {
    isLoading.value = true
    loadError.value = ''
    try {
        const config = useRuntimeConfig()
        const token = useCookie('token').value || (process.client ? localStorage.getItem('token') : '')

        // Format dates to ISO string if provided
        const queryParams = {
            page,
            limit: pagination.limit,
            exportedDataType: filters.exportedDataType || undefined,
        }
        
        if (filters.startDate) {
            queryParams.startDate = new Date(filters.startDate).toISOString()
        }
        if (filters.endDate) {
            queryParams.endDate = new Date(filters.endDate).toISOString()
        }

        const res = await $fetch('/export-logs/admin', {
            baseURL: config.public.apiBase,
            headers: { Accept: 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
            query: queryParams,
        })

        const list = res?.data || []
        const p = res?.totalPages ? res : {}
        logs.value = list
        pagination.page = Number(p.page ?? page)
        pagination.limit = Number(p.limit ?? pagination.limit)
        pagination.total = Number(p.total ?? 0)
        pagination.totalPages = Number(p.totalPages ?? Math.ceil(pagination.total / pagination.limit))
    } catch (err) {
        console.error(err)
        loadError.value = err?.data?.message || 'ไม่สามารถโหลดข้อมูลได้'
        toast.error('เกิดข้อผิดพลาด', loadError.value)
        logs.value = []
    } finally {
        isLoading.value = false
    }
}

function changePage(next) {
    if (next < 1 || next > totalPages.value) return
    fetchLogs(next)
}

function applyFilters() {
    // Validate date range if both dates are provided
    if (filters.startDate && filters.endDate) {
        const start = new Date(filters.startDate)
        const end = new Date(filters.endDate)
        if (start > end) {
            toast.error('เกิดข้อผิดพลาด', 'วันที่เริ่มต้นต้องมาก่อนวันที่สิ้นสุด')
            return
        }
    }
    
    pagination.page = 1
    fetchLogs(1)
    toast.success('สำเร็จ', 'ใช้ตัวกรองเรียบร้อยแล้ว')
}

function clearFilters() {
    filters.startDate = ''
    filters.endDate = ''
    filters.exportedDataType = ''
    pagination.page = 1
    fetchLogs(1)
    toast.success('สำเร็จ', 'ล้างตัวกรองเรียบร้อยแล้ว')
}

function openDetailModal(log) {
    selectedLog.value = log
    showDetailModal.value = true
}

function closeDetailModal() {
    showDetailModal.value = false
    selectedLog.value = null
}

function closeMobileSidebar() {
    const sidebar = document.getElementById('sidebar')
    const overlay = document.getElementById('overlay')
    if (!sidebar || !overlay) return
    sidebar.classList.remove('mobile-open')
    overlay.classList.add('hidden')
}

function defineGlobalScripts() {
    window.toggleSidebar = function () {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('main-content');
        const toggleIcon = document.getElementById('toggle-icon');

        if (!sidebar || !mainContent || !toggleIcon) return;

        sidebar.classList.toggle('collapsed');

        if (sidebar.classList.contains('collapsed')) {
            mainContent.style.marginLeft = '80px';
            toggleIcon.classList.replace('fa-chevron-left', 'fa-chevron-right');
        } else {
            mainContent.style.marginLeft = '280px';
            toggleIcon.classList.replace('fa-chevron-right', 'fa-chevron-left');
        }
    }

    window.toggleMobileSidebar = function () {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('overlay');

        if (!sidebar || !overlay) return;

        sidebar.classList.toggle('mobile-open');
        overlay.classList.toggle('hidden');
    }

    window.toggleSubmenu = function (menuId) {
        const menu = document.getElementById(menuId);
        const icon = document.getElementById(menuId + '-icon');

        if (!menu || !icon) return;

        menu.classList.toggle('hidden');

        if (menu.classList.contains('hidden')) {
            icon.classList.replace('fa-chevron-up', 'fa-chevron-down');
        } else {
            icon.classList.replace('fa-chevron-down', 'fa-chevron-up');
        }
    }

    window.__adminResizeHandler__ = function () {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('main-content');
        const overlay = document.getElementById('overlay');

        if (!sidebar || !mainContent || !overlay) return;

        if (window.innerWidth >= 1024) {
            sidebar.classList.remove('mobile-open');
            overlay.classList.add('hidden');

            if (sidebar.classList.contains('collapsed')) {
                mainContent.style.marginLeft = '80px';
            } else {
                mainContent.style.marginLeft = '280px';
            }
        } else {
            mainContent.style.marginLeft = '0';
        }
    }

    window.addEventListener('resize', window.__adminResizeHandler__)
}

function cleanupGlobalScripts() {
    window.removeEventListener('resize', window.__adminResizeHandler__ || (() => { }))
    delete window.toggleSidebar
    delete window.toggleMobileSidebar
    delete window.closeMobileSidebar
    delete window.toggleSubmenu
    delete window.__adminResizeHandler__
}

onMounted(() => {
    defineGlobalScripts()
    if (typeof window.__adminResizeHandler__ === 'function') window.__adminResizeHandler__()
    fetchLogs(1)
})

onUnmounted(() => {
    cleanupGlobalScripts()
})

useHead({
    title: 'Export Log - Admin Dashboard',
    link: [{ rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css' }]
})
</script>

<style scoped>
.sidebar {
    transition: width 0.3s ease;
}

.sidebar.collapsed {
    width: 80px;
}

.sidebar:not(.collapsed) {
    width: 280px;
}

.sidebar-item {
    transition: all 0.3s ease;
}

.sidebar-item:hover {
    background-color: rgba(59, 130, 246, 0.05);
}

.sidebar.collapsed .sidebar-text {
    display: none;
}

.sidebar.collapsed .sidebar-item {
    justify-content: center;
}

.main-content {
    transition: margin-left 0.3s ease;
}

@media (max-width: 768px) {
    .sidebar {
        position: fixed;
        z-index: 1000;
        transform: translateX(-100%);
    }

    .sidebar.mobile-open {
        transform: translateX(0);
    }

    .main-content {
        margin-left: 0 !important;
    }
}
</style>
