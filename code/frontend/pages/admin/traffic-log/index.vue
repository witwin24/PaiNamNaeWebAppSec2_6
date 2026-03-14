<template>
  <div class="">
    <AdminHeader />
    <AdminSidebar />

    <!-- Main Content -->
    <main id="main-content" class="main-content mt-16 ml-0 lg:ml-[280px] p-6">
      <!-- Page Title -->
      <div class="mx-auto max-w-8xl">
        <!-- Title -->
        <div
          class="flex flex-col gap-3 mb-6 sm:flex-row sm:items-center sm:justify-between"
        >
          <h1 class="text-2xl font-semibold text-gray-800">Traffic Log</h1>
        </div>

        <!-- Advanced Filters -->
        <div class="mb-4 bg-white border border-gray-300 rounded-lg shadow-sm">
          <div
            class="grid grid-cols-1 gap-3 px-4 py-4 sm:px-6 lg:grid-cols-[repeat(24,minmax(0,1fr))]"
          >
            <!-- User ID (5/24) -->
            <div class="lg:col-span-5">
              <label class="block mb-1 text-xs font-medium text-gray-600">User ID</label>
              <input
                v-model="filters.userId"
                type="text"
                id="userID"
                placeholder="ระบุ User ID"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500"
              />
            </div>

            <!-- Start Time (5/24) -->
            <div class="lg:col-span-5">
              <label class="block mb-1 text-xs font-medium text-gray-600"
                >เวลาเริ่มต้น</label
              >
              <input
                v-model="filters.startDate"
                type="datetime-local"
                id="startTime"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500"
              />
            </div>

            <!-- End Time (5/24) -->
            <div class="lg:col-span-5">
              <label class="block mb-1 text-xs font-medium text-gray-600"
                >เวลาสิ้นสุด</label
              >
              <input
                v-model="filters.endDate"
                type="datetime-local"
                id="endTime"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500"
              />
            </div>

            <!-- Actions (4/24) -->
            <div class="flex items-end justify-end gap-2 mt-1 lg:col-span-9 lg:mt-0">
              <button
                @click="clearFilters"
                class="px-3 py-2 text-gray-700 border border-gray-300 rounded-md cursor-pointer hover:bg-gray-50"
                id="clearFilters"
              >
                ล้างตัวกรอง
              </button>
              <button
                @click="applyFilters"
                class="px-4 py-2 text-white bg-blue-600 rounded-md cursor-pointer hover:bg-blue-700"
                id="applyFilters"
              >
                ใช้ตัวกรอง
              </button>
            </div>
          </div>
        </div>

        <!-- Card -->
        <div class="bg-white border border-gray-300 rounded-lg shadow-sm">
          <div
            class="flex items-center justify-between px-4 py-4 border-b border-gray-200 sm:px-6"
          >
            <div class="text-sm text-gray-600">
              หน้าที่ {{ pagination.page }} / {{ totalPages }} • ทั้งหมด
              {{ pagination.total }} รายการ
            </div>
            <!-- Export Button -->
            <div class="flex justify-end mt-4">
              <button
                @click="exportLogs"
                :disabled="isExporting"
                class="px-4 py-2 text-white bg-green-600 rounded-md hover:bg-green-700 disabled:opacity-50"
              >
                {{ isExporting ? "Exporting..." : "Export" }}
              </button>
            </div>
          </div>

          <!-- Loading / Error -->
          <div v-if="isLoading" class="p-8 text-center text-gray-500">
            กำลังโหลดข้อมูล...
          </div>
          <div v-else-if="loadError" class="p-8 text-center text-red-600">
            {{ loadError }}
          </div>

          <!-- Table -->
          <div v-else class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase"
                  >
                    User ID
                  </th>
                  <th
                    class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase"
                  >
                    Timestamp
                  </th>
                  <th
                    class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase"
                  >
                    Source IP
                  </th>
                  <th
                    class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase"
                  >
                    Destination URL
                  </th>

                  <th
                    class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase"
                  >
                    Method
                  </th>
                  <th
                    class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase"
                  >
                    Status Code
                  </th>
                  <th
                    class="px-4 py-3 text-xs font-medium text-left text-gray-500 uppercase"
                  >
                    Action
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr
                  v-for="log in logs"
                  :key="log.id"
                  class="transition-opacity hover:bg-gray-50"
                >
                  <td class="px-4 py-3">
                    <span class="font-mono text-sm text-gray-700">{{
                      log.userId || "-"
                    }}</span>
                  </td>
                  <td class="px-4 py-3 text-sm text-gray-700 whitespace-nowrap">
                    {{ formatDate(log.timestamp) }}
                  </td>
                  <td class="px-4 py-3">
                    <span class="font-mono text-sm text-gray-700">{{
                      log.sourceIp || "-"
                    }}</span>
                  </td>
                  <td class="px-4 py-3">
                    <div
                      class="max-w-xs text-sm text-gray-700 truncate"
                      :title="log.destinationUrl"
                    >
                      {{ log.destinationUrl || "-" }}
                    </div>
                  </td>
                  <td class="px-4 py-3">
                    <span
                      class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full"
                      :class="getMethodBadge(log.method)"
                    >
                      {{ log.method }}
                    </span>
                  </td>
                  <td class="px-4 py-3">
                    <span
                      class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full"
                      :class="getStatusBadge(log.statusCode)"
                    >
                      {{ log.statusCode }}
                    </span>
                  </td>
                  <td class="px-4 py-3">
                    <span class="text-sm text-gray-700">{{ log.action || "-" }}</span>
                  </td>
                </tr>

                <tr v-if="!logs.length">
                  <td colspan="7" class="px-4 py-10 text-center text-gray-500">
                    ไม่มีข้อมูล Traffic Log
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div
            class="flex flex-col gap-3 px-4 py-4 border-t border-gray-200 sm:px-6 sm:flex-row sm:items-center sm:justify-between"
          >
            <div class="flex flex-wrap items-center gap-3 text-sm">
              <div class="flex items-center gap-2">
                <span class="text-xs text-gray-500">Limit:</span>
                <select
                  v-model.number="pagination.limit"
                  @change="applyFilters"
                  id="limit"
                  class="px-2 py-1 text-sm border border-gray-300 rounded-md focus:ring-blue-500"
                >
                  <option id="20" :value="20">20</option>
                  <option id="50" :value="50">50</option>
                  <option id="100" :value="100">100</option>
                </select>
              </div>
            </div>

            <nav class="flex items-center gap-1">
              <button
                id="Previous"
                class="px-3 py-2 text-sm border rounded-md disabled:opacity-50"
                :disabled="pagination.page <= 1 || isLoading"
                @click="changePage(pagination.page - 1)"
              >
                Previous
              </button>

              <template v-for="(p, idx) in pageButtons">
                <span
                  v-if="p === '…'"
                  :key="`ellipsis-${idx}`"
                  class="px-2 text-sm text-gray-500"
                  >…</span
                >
                <button
                  v-else
                  :key="`page-${p}`"
                  class="px-3 py-2 text-sm border rounded-md"
                  :class="
                    p === pagination.page
                      ? 'bg-blue-50 text-blue-600 border-blue-200'
                      : 'hover:bg-gray-50'
                  "
                  :disabled="isLoading"
                  @click="changePage(p)"
                >
                  {{ p }}
                </button>
              </template>

              <button
                id="next"
                class="px-3 py-2 text-sm border rounded-md disabled:opacity-50"
                :disabled="pagination.page >= totalPages || isLoading"
                @click="changePage(pagination.page + 1)"
              >
                Next
              </button>
            </nav>
          </div>
        </div>
      </div>
    </main>

    <!-- Mobile Overlay -->
    <div
      id="overlay"
      class="fixed inset-0 z-40 hidden bg-black bg-opacity-50 lg:hidden"
      @click="closeMobileSidebar"
    ></div>

    <!-- Password Confirmation Modal -->
    <transition name="modal-fade">
      <div
        v-if="showPasswordModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
        @click.self="showPasswordModal = false"
      >
        <div class="bg-white rounded-lg shadow-xl max-w-sm w-full mx-4">
          <div class="px-6 py-4 border-b border-gray-200">
            <h2 class="text-xl font-semibold text-gray-900">ยืนยันตัวตน</h2>
            <p class="text-sm text-gray-600 mt-1">
              กรุณากรอกรหัสผ่านของคุณเพื่อยืนยันตัวตน
            </p>
          </div>

          <div class="px-6 py-4">
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700 mb-2">
                รหัสผ่าน
              </label>
              <input
                v-model="adminPassword"
                type="password"
                placeholder="กรอกรหัสผ่าน"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                @keyup.enter="verifyAndExport"
              />
            </div>

            <div
              v-if="passwordError"
              class="mb-4 p-3 bg-red-50 border border-red-200 rounded-md"
            >
              <p class="text-sm text-red-600">{{ passwordError }}</p>
            </div>
          </div>

          <div class="px-6 py-4 border-t border-gray-200 flex justify-end gap-3">
            <button
              @click="showPasswordModal = false"
              class="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50 transition-colors"
            >
              ยกเลิก
            </button>
            <button
              @click="verifyAndExport"
              :disabled="!adminPassword || isExporting"
              class="px-4 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {{ isExporting ? "กำลังส่งออก..." : "ยืนยัน" }}
            </button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted } from "vue";
import { useRuntimeConfig, useCookie } from "#app";
import dayjs from "dayjs";
import "dayjs/locale/th";
import buddhistEra from "dayjs/plugin/buddhistEra";
import AdminHeader from "~/components/admin/AdminHeader.vue";
import AdminSidebar from "~/components/admin/AdminSidebar.vue";
import { useToast } from "~/composables/useToast";

dayjs.locale("th");
dayjs.extend(buddhistEra);

definePageMeta({ middleware: ["admin-auth"] });

const { toast } = useToast();

const isLoading = ref(false);
const loadError = ref("");
const logs = ref([]);

const pagination = reactive({
  page: 1,
  limit: 20,
  total: 0,
  totalPages: 1,
});

const filters = reactive({
  userId: "",
  startDate: "",
  endDate: "",
});

const totalPages = computed(() =>
  Math.max(
    1,
    pagination.totalPages || Math.ceil((pagination.total || 0) / (pagination.limit || 20))
  )
);

const pageButtons = computed(() => {
  const total = totalPages.value;
  const current = pagination.page;
  if (!total || total < 1) return [];
  if (total <= 5) return Array.from({ length: total }, (_, i) => i + 1);
  const set = new Set([1, total, current]);
  if (current - 1 > 1) set.add(current - 1);
  if (current + 1 < total) set.add(current + 1);
  const pages = Array.from(set).sort((a, b) => a - b);
  const out = [];
  for (let i = 0; i < pages.length; i++) {
    if (i > 0 && pages[i] - pages[i - 1] > 1) out.push("…");
    out.push(pages[i]);
  }
  return out;
});

function getMethodBadge(method) {
  const badges = {
    GET: "bg-blue-100 text-blue-700",
    POST: "bg-green-100 text-green-700",
    PUT: "bg-yellow-100 text-yellow-700",
    PATCH: "bg-orange-100 text-orange-700",
    DELETE: "bg-red-100 text-red-700",
  };
  return badges[method] || "bg-gray-100 text-gray-700";
}

function getStatusBadge(status) {
  if (status >= 200 && status < 300) return "bg-green-100 text-green-700";
  if (status >= 300 && status < 400) return "bg-blue-100 text-blue-700";
  if (status >= 400 && status < 500) return "bg-yellow-100 text-yellow-700";
  if (status >= 500) return "bg-red-100 text-red-700";
  return "bg-gray-100 text-gray-700";
}

function formatDate(iso) {
  if (!iso) return "-";
  return dayjs(iso).subtract(7, "hour").format("D MMM BBBB HH:mm:ss");
}

async function fetchLogs(page = 1) {
  isLoading.value = true;
  loadError.value = "";
  try {
    const config = useRuntimeConfig();
    const token =
      useCookie("token").value || (process.client ? localStorage.getItem("token") : "");

    // Format dates to ISO string if provided
    const queryParams = {
      page,
      limit: pagination.limit,
      userId: filters.userId || undefined,
    };

    if (filters.startDate) {
      queryParams.startDate = new Date(filters.startDate).toISOString();
    }
    if (filters.endDate) {
      queryParams.endDate = new Date(filters.endDate).toISOString();
    }

    const res = await $fetch("/traffic-logs/admin", {
      baseURL: config.public.apiBase,
      headers: {
        Accept: "application/json",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      query: queryParams,
    });

    const list = res?.data || [];
    const p = res?.totalPages ? res : {};
    logs.value = list;
    pagination.page = Number(p.page ?? page);
    pagination.limit = Number(p.limit ?? pagination.limit);
    pagination.total = Number(p.total ?? 0);
    pagination.totalPages = Number(
      p.totalPages ?? Math.ceil(pagination.total / pagination.limit)
    );
  } catch (err) {
    console.error(err);
    loadError.value = err?.data?.message || "ไม่สามารถโหลดข้อมูลได้";
    toast.error("เกิดข้อผิดพลาด", loadError.value);
    logs.value = [];
  } finally {
    isLoading.value = false;
  }
}

function changePage(next) {
  if (next < 1 || next > totalPages.value) return;
  fetchLogs(next);
}

function applyFilters() {
  // Validate date range if both dates are provided
  if (filters.startDate && filters.endDate) {
    const start = new Date(filters.startDate);
    const end = new Date(filters.endDate);
    if (start > end) {
      toast.error("เกิดข้อผิดพลาด", "วันที่เริ่มต้นต้องมาก่อนวันที่สิ้นสุด");
      return;
    }
  }

  pagination.page = 1;
  fetchLogs(1);
  toast.success("สำเร็จ", "ใช้ตัวกรองเรียบร้อยแล้ว");
}

function clearFilters() {
  filters.userId = "";
  filters.startDate = "";
  filters.endDate = "";
  pagination.page = 1;
  fetchLogs(1);
  toast.success("สำเร็จ", "ล้างตัวกรองเรียบร้อยแล้ว");
}

function closeMobileSidebar() {
  const sidebar = document.getElementById("sidebar");
  const overlay = document.getElementById("overlay");
  if (!sidebar || !overlay) return;
  sidebar.classList.remove("mobile-open");
  overlay.classList.add("hidden");
}

function defineGlobalScripts() {
  window.toggleSidebar = function () {
    const sidebar = document.getElementById("sidebar");
    const mainContent = document.getElementById("main-content");
    const toggleIcon = document.getElementById("toggle-icon");

    if (!sidebar || !mainContent || !toggleIcon) return;

    sidebar.classList.toggle("collapsed");

    if (sidebar.classList.contains("collapsed")) {
      mainContent.style.marginLeft = "80px";
      toggleIcon.classList.replace("fa-chevron-left", "fa-chevron-right");
    } else {
      mainContent.style.marginLeft = "280px";
      toggleIcon.classList.replace("fa-chevron-right", "fa-chevron-left");
    }
  };

  window.toggleMobileSidebar = function () {
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("overlay");

    if (!sidebar || !overlay) return;

    sidebar.classList.toggle("mobile-open");
    overlay.classList.toggle("hidden");
  };

  window.toggleSubmenu = function (menuId) {
    const menu = document.getElementById(menuId);
    const icon = document.getElementById(menuId + "-icon");

    if (!menu || !icon) return;

    menu.classList.toggle("hidden");

    if (menu.classList.contains("hidden")) {
      icon.classList.replace("fa-chevron-up", "fa-chevron-down");
    } else {
      icon.classList.replace("fa-chevron-down", "fa-chevron-up");
    }
  };

  window.__adminResizeHandler__ = function () {
    const sidebar = document.getElementById("sidebar");
    const mainContent = document.getElementById("main-content");
    const overlay = document.getElementById("overlay");

    if (!sidebar || !mainContent || !overlay) return;

    if (window.innerWidth >= 1024) {
      sidebar.classList.remove("mobile-open");
      overlay.classList.add("hidden");

      if (sidebar.classList.contains("collapsed")) {
        mainContent.style.marginLeft = "80px";
      } else {
        mainContent.style.marginLeft = "280px";
      }
    } else {
      mainContent.style.marginLeft = "0";
    }
  };

  window.addEventListener("resize", window.__adminResizeHandler__);
}

function cleanupGlobalScripts() {
  window.removeEventListener("resize", window.__adminResizeHandler__ || (() => {}));
  delete window.toggleSidebar;
  delete window.toggleMobileSidebar;
  delete window.closeMobileSidebar;
  delete window.toggleSubmenu;
  delete window.__adminResizeHandler__;
}

// Loading and modal states
const isExporting = ref(false);
const showPasswordModal = ref(false);
const adminPassword = ref("");
const passwordError = ref("");

async function verifyAndExport() {
  try {
    // Verify password with backend
    const config = useRuntimeConfig();
    const token =
      useCookie("token").value || (process.client ? localStorage.getItem("token") : "");

    // Logic การยืนยันรหัสผ่านแอดมินก่อนส่งออกข้อมูล
    const verifyRes = await fetch(`${config.public.apiBase}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify({
        password: adminPassword.value,
      }),
    });

    if (!verifyRes.ok) {
      const error = await verifyRes.json();
      passwordError.value = error?.message || "รหัสผ่านไม่ถูกต้อง";
      return;
    }

    // Password verified, proceed with export
    showPasswordModal.value = false;
    adminPassword.value = "";
    passwordError.value = "";
    await performExport();
  } catch (err) {
    console.error("Password verification error:", err);
    passwordError.value = "เกิดข้อผิดพลาดในการตรวจสอบ";
  }
}

async function performExport() {
  try {
    isExporting.value = true;

    const config = useRuntimeConfig();
    const token =
      useCookie("token").value || (process.client ? localStorage.getItem("token") : "");

    const query = new URLSearchParams({
      userId: filters.userId || "",
      startDate: filters.startDate || "",
      endDate: filters.endDate || "",
    });

    const res = await fetch(
      `${config.public.apiBase}/traffic-logs/admin/export?${query}`,
      {
        method: "GET",
        headers: {
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
        },
      }
    );

    if (!res.ok) throw new Error("Export failed");

    const blob = await res.blob();

    const url = window.URL.createObjectURL(blob);

    const a = document.createElement("a");
    a.href = url;
    a.download = `traffic_logs_${Date.now()}.zip`;
    document.body.appendChild(a);
    a.click();
    a.remove();

    window.URL.revokeObjectURL(url);

    // บันทึก Export Log
    await fetch(`${config.public.apiBase}/export-logs/admin`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify({
        startDate: filters.startDate || null,
        endDate: filters.endDate || null,
        exportType: "TRAFFIC_LOG",
        securityMeasure: "SHA256 Integrity + Verify Script",
        exportedAt: new Date().toISOString(),
      }),
    });

    toast.success("สำเร็จ", "ส่งออก Traffic Log พร้อมไฟล์ตรวจสอบ SHA256");
  } catch (err) {
    console.error("Export error:", err);
    toast.error("เกิดข้อผิดพลาด", "ไม่สามารถส่งออกข้อมูลได้");
  } finally {
    isExporting.value = false;
  }
}

function exportLogs() {
  showPasswordModal.value = true;
  passwordError.value = "";
  adminPassword.value = "";
}

onMounted(() => {
  defineGlobalScripts();
  if (typeof window.__adminResizeHandler__ === "function")
    window.__adminResizeHandler__();
  fetchLogs(1);
});

onUnmounted(() => {
  cleanupGlobalScripts();
});

useHead({
  title: "Traffic Log - Admin Dashboard",
  link: [
    {
      rel: "stylesheet",
      href: "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css",
    },
  ],
});
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

.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.3s ease;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-fade-enter-to,
.modal-fade-leave-from {
  opacity: 1;
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
