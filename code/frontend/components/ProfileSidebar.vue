<template>
  <aside class="w-80 bg-gray-50 p-6 border-r border-gray-200 hidden md:block">
    <div class="mb-8">
      <h1 class="text-xl font-bold text-gray-900 text-center mb-2">
        โปรไฟล์และการตั้งค่า
      </h1>
      <p class="text-sm text-gray-600 text-center">
        จัดการข้อมูลส่วนตัวและความปลอดภัยของบัญชี
      </p>
    </div>
    <nav class="space-y-4">
      <div>
        <h3 class="text-sm font-semibold text-gray-900 mb-2 px-4">การจัดการบัญชี</h3>
        <ul class="space-y-1">
          <li>
            <NuxtLink
              to="/profile"
              class="block px-4 py-2 text-sm rounded-md"
              :class="
                isActive('/profile')
                  ? 'font-semibold text-blue-600 bg-blue-100'
                  : 'text-gray-700 hover:bg-gray-100'
              "
            >
              โปรไฟล์ของฉัน
            </NuxtLink>

            <!-- ปุ่มลบบัญชี -->
            <button
              @click="openDeleteModal"
              class="block px-4 py-2 text-sm rounded-md text-red-600 hover:bg-red-50"
            >
              ลบบัญชีของฉัน
            </button>

            <!-- Modal -->
            <div
              v-if="showModal"
              class="fixed inset-0 flex items-center justify-center bg-slate-200/35 backdrop-blur-sm z-50"
            >
              <div class="bg-white w-[26rem] rounded-xl p-6 shadow-xl">

                <!-- Step 1: เลือกข้อมูล -->
                <template v-if="deleteStep === 1">
                  <h2 class="text-lg font-semibold text-red-600 mb-1">ลบบัญชีของฉัน</h2>
                  <p class="text-sm text-gray-500 mb-4">
                    เลือกข้อมูลที่ต้องการรวมในไฟล์สำรองก่อนลบบัญชี
                    ข้อมูลจะถูกส่งไปยัง Email ของคุณเป็น Zip file
                  </p>

                  <div class="space-y-3 mb-6">
                    <p v-if="isCheckingAvailability" class="text-xs text-gray-500">
                      กำลังตรวจสอบข้อมูลที่มีอยู่...
                    </p>

                    <!-- เลือกทั้งหมด -->
                    <label class="flex items-start gap-3 cursor-pointer group border-b border-gray-100 pb-3">
                      <input
                        type="checkbox"
                        :checked="selectAll"
                        @change="toggleSelectAll"
                        class="mt-0.5 h-4 w-4 rounded border-gray-300 text-red-600 focus:ring-red-500"
                      />
                      <div>
                        <p class="text-sm font-semibold text-gray-900 group-hover:text-red-600 transition-colors">
                          เลือกทั้งหมด
                        </p>
                        <p class="text-xs text-gray-500">เลือกหรือยกเลิกการเลือกข้อมูลทั้งหมดในครั้งเดียว</p>
                      </div>
                    </label>

                    <!-- ข้อมูลส่วนตัว (ทุกคน) -->
                    <label class="flex items-start gap-3 cursor-pointer group">
                      <input
                        type="checkbox"
                        v-model="deleteSelection.personalInfo"
                        class="mt-0.5 h-4 w-4 rounded border-gray-300 text-red-600 focus:ring-red-500"
                      />
                      <div>
                        <p class="text-sm font-medium text-gray-800 group-hover:text-red-600 transition-colors">ข้อมูลส่วนตัว</p>
                        <p class="text-xs text-gray-500">ชื่อ, อีเมล, เบอร์โทรศัพท์ และข้อมูลบัญชี</p>
                      </div>
                    </label>

                    <!-- ข้อมูลใบขับขี่ (ถ้ามีข้อมูล) -->
                    <label v-if="dataAvailability.driverLicense" class="flex items-start gap-3 cursor-pointer group">
                      <input
                        type="checkbox"
                        v-model="deleteSelection.driverLicense"
                        class="mt-0.5 h-4 w-4 rounded border-gray-300 text-red-600 focus:ring-red-500"
                      />
                      <div>
                        <p class="text-sm font-medium text-gray-800 group-hover:text-red-600 transition-colors">
                          ข้อมูลใบขับขี่
                          <span class="ml-1 text-xs font-normal text-blue-500">(มีข้อมูลอยู่ในระบบ)</span>
                        </p>
                        <p class="text-xs text-gray-500">ข้อมูลการยืนยันตัวตนและใบขับขี่</p>
                      </div>
                    </label>

                    <!-- ข้อมูลยานพาหนะ (ถ้ามีข้อมูล) -->
                    <label v-if="dataAvailability.vehicle" class="flex items-start gap-3 cursor-pointer group">
                      <input
                        type="checkbox"
                        v-model="deleteSelection.vehicle"
                        class="mt-0.5 h-4 w-4 rounded border-gray-300 text-red-600 focus:ring-red-500"
                      />
                      <div>
                        <p class="text-sm font-medium text-gray-800 group-hover:text-red-600 transition-colors">
                          ข้อมูลยานพาหนะ
                          <span class="ml-1 text-xs font-normal text-blue-500">(มีข้อมูลอยู่ในระบบ)</span>
                        </p>
                        <p class="text-xs text-gray-500">รายละเอียดรถและทะเบียนยานพาหนะ</p>
                      </div>
                    </label>

                    <!-- ประวัติเส้นทาง (ถ้ามีข้อมูล) -->
                    <label v-if="dataAvailability.routeHistory" class="flex items-start gap-3 cursor-pointer group">
                      <input
                        type="checkbox"
                        v-model="deleteSelection.routeHistory"
                        class="mt-0.5 h-4 w-4 rounded border-gray-300 text-red-600 focus:ring-red-500"
                      />
                      <div>
                        <p class="text-sm font-medium text-gray-800 group-hover:text-red-600 transition-colors">
                          ประวัติเส้นทาง
                          <span class="ml-1 text-xs font-normal text-blue-500">(มีข้อมูลอยู่ในระบบ)</span>
                        </p>
                        <p class="text-xs text-gray-500">เส้นทางและการเดินทางที่สร้างไว้ทั้งหมด</p>
                      </div>
                    </label>

                    <!-- ประวัติการจอง (ผู้โดยสาร) -->
                    <label v-if="dataAvailability.bookingHistory" class="flex items-start gap-3 cursor-pointer group">
                      <input
                        type="checkbox"
                        v-model="deleteSelection.bookingHistory"
                        class="mt-0.5 h-4 w-4 rounded border-gray-300 text-red-600 focus:ring-red-500"
                      />
                      <div>
                        <p class="text-sm font-medium text-gray-800 group-hover:text-red-600 transition-colors">
                          ประวัติการจอง
                          <span class="ml-1 text-xs font-normal text-purple-500">(มีข้อมูลอยู่ในระบบ)</span>
                        </p>
                        <p class="text-xs text-gray-500">รายการจองที่เคยทำทั้งหมด</p>
                      </div>
                    </label>
                  </div>

                  <div class="flex justify-end gap-2">
                    <button
                      @click="closeDeleteModal"
                      class="px-4 py-2 text-sm rounded-md bg-gray-200 hover:bg-gray-300"
                    >
                      ยกเลิก
                    </button>
                    <button
                      @click="deleteStep = 2"
                      class="px-4 py-2 text-sm rounded-md bg-red-600 text-white hover:bg-red-700"
                    >
                      ถัดไป
                    </button>
                  </div>
                </template>

                <!-- Step 2: กรอกรหัสผ่าน -->
                <template v-else-if="deleteStep === 2">
                  <h2 class="text-lg font-semibold text-red-600 mb-1">ยืนยันการลบบัญชี</h2>
                  <p class="text-sm text-gray-500 mb-4">
                    การลบบัญชีจะไม่สามารถกู้คืนได้ กรุณากรอกรหัสผ่านเพื่อยืนยัน
                  </p>

                  <!-- สรุปข้อมูลที่เลือก -->
                  <div class="bg-gray-50 rounded-lg p-3 mb-4 text-xs text-gray-600 space-y-1">
                    <p class="font-medium text-gray-700 mb-1">ข้อมูลที่จะรวมในไฟล์สำรอง:</p>
                    <p v-if="deleteSelection.personalInfo" class="flex items-center gap-1">
                      <span class="text-green-500">✓</span> ข้อมูลส่วนตัว
                    </p>
                    <p v-if="dataAvailability.driverLicense && deleteSelection.driverLicense" class="flex items-center gap-1">
                      <span class="text-green-500">✓</span> ข้อมูลใบขับขี่
                    </p>
                    <p v-if="dataAvailability.vehicle && deleteSelection.vehicle" class="flex items-center gap-1">
                      <span class="text-green-500">✓</span> ข้อมูลยานพาหนะ
                    </p>
                    <p v-if="dataAvailability.routeHistory && deleteSelection.routeHistory" class="flex items-center gap-1">
                      <span class="text-green-500">✓</span> ประวัติเส้นทาง
                    </p>
                    <p v-if="dataAvailability.bookingHistory && deleteSelection.bookingHistory" class="flex items-center gap-1">
                      <span class="text-green-500">✓</span> ประวัติการจอง
                    </p>
                    <p
                      v-if="!deleteSelection.personalInfo && !deleteSelection.driverLicense && !deleteSelection.vehicle && !deleteSelection.routeHistory && !deleteSelection.bookingHistory"
                      class="text-gray-400 italic"
                    >
                      ไม่ได้เลือกข้อมูลใด
                    </p>
                  </div>

                  <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-2">กรอกรหัสผ่าน</label>
                    <input
                      v-model="password"
                      type="password"
                      placeholder="กรอกรหัสผ่าน"
                      class="w-full border rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-red-400"
                    />
                  </div>

                  <div class="flex justify-end gap-2">
                    <button
                      @click="deleteStep = 1"
                      class="px-4 py-2 text-sm rounded-md bg-gray-200 hover:bg-gray-300"
                    >
                      ย้อนกลับ
                    </button>
                    <button
                      @click="confirmDelete"
                      :disabled="loading"
                      class="px-4 py-2 text-sm rounded-md bg-red-600 text-white hover:bg-red-700 disabled:opacity-50"
                    >
                      {{ loading ? "กำลังลบ..." : "ยืนยันการลบ" }}
                    </button>
                  </div>
                </template>

              </div>
            </div>
          </li>
        </ul>
      </div>
      <div>
        <h3 class="text-sm font-semibold text-gray-900 mb-2 px-4">การยืนยันตัวตน</h3>
        <ul class="space-y-1">
          <li>
            <NuxtLink
              to="/profile/verification"
              class="block px-4 py-2 text-sm rounded-md"
              :class="
                isActive('/profile/verification')
                  ? 'font-semibold text-blue-600 bg-blue-100'
                  : 'text-gray-700 hover:bg-gray-100'
              "
            >
              การยืนยันตัวตนขั้นพื้นฐาน
            </NuxtLink>
          </li>
          <li>
            <NuxtLink
              to="/profile/driver-verification"
              class="block px-4 py-2 text-sm rounded-md"
              :class="
                isActive('/profile/driver-verification')
                  ? 'font-semibold text-blue-600 bg-blue-100'
                  : 'text-gray-700 hover:bg-gray-100'
              "
            >
              การยืนยันตัวตนสำหรับผู้ขับขี่
            </NuxtLink>
          </li>
        </ul>
      </div>
      <div>
        <h3 class="text-sm font-semibold text-gray-900 mb-2 px-4">โหมดผู้ขับขี่</h3>
        <ul class="space-y-1">
          <li>
            <NuxtLink
              to="/profile/my-vehicle"
              class="block px-4 py-2 text-sm rounded-md"
              :class="
                isActive('/profile/my-vehicle')
                  ? 'font-semibold text-blue-600 bg-blue-100'
                  : 'text-gray-700 hover:bg-gray-100'
              "
            >
              ข้อมูลรถยนต์ของฉัน
            </NuxtLink>
          </li>
        </ul>
      </div>
    </nav>
  </aside>
</template>

<script setup>
import { ref, computed } from "vue";
import { useRoute } from "vue-router";

const route = useRoute();

const isActive = (path) => route.path === path;

const { $api } = useNuxtApp();

// สถานะ modal
const showModal = ref(false);
const deleteStep = ref(1); // 1 = เลือกข้อมูล, 2 = กรอกรหัสผ่าน
const password = ref("");
const loading = ref(false);

// ข้อมูลที่ต้องการรวมในไฟล์สำรอง
const deleteSelection = ref({
  personalInfo: true,
  driverLicense: false,
  vehicle: false,
  routeHistory: false,
  bookingHistory: false,
});

const isCheckingAvailability = ref(false);
const dataAvailability = ref({
  driverLicense: false,
  vehicle: false,
  routeHistory: false,
  bookingHistory: false,
});

const hasData = (value) => {
  if (Array.isArray(value)) return value.length > 0;
  if (!value || typeof value !== "object") return false;
  return Object.keys(value).length > 0;
};

const checkDataAvailability = async () => {
  isCheckingAvailability.value = true;
  try {
    const [driverLicenseRes, vehicleRes, routeRes, bookingRes] = await Promise.allSettled([
      $api("/driver-verifications/me"),
      $api("/vehicles"),
      $api("/routes/me"),
      $api("/bookings/me"),
    ]);

    dataAvailability.value.driverLicense =
      driverLicenseRes.status === "fulfilled" && hasData(driverLicenseRes.value);
    dataAvailability.value.vehicle =
      vehicleRes.status === "fulfilled" && hasData(vehicleRes.value);
    dataAvailability.value.routeHistory =
      routeRes.status === "fulfilled" && hasData(routeRes.value);
    dataAvailability.value.bookingHistory =
      bookingRes.status === "fulfilled" && hasData(bookingRes.value);
  } finally {
    isCheckingAvailability.value = false;
  }
};

const openDeleteModal = async () => {
  deleteStep.value = 1;
  showModal.value = true;
  await checkDataAvailability();
};

const visibleKeys = computed(() => {
  const keys = ["personalInfo"];
  if (dataAvailability.value.driverLicense) keys.push("driverLicense");
  if (dataAvailability.value.vehicle) keys.push("vehicle");
  if (dataAvailability.value.routeHistory) keys.push("routeHistory");
  if (dataAvailability.value.bookingHistory) keys.push("bookingHistory");
  return keys;
});

const selectAll = computed(() => visibleKeys.value.every((key) => deleteSelection.value[key]));

const toggleSelectAll = () => {
  const shouldCheckAll = !selectAll.value;
  visibleKeys.value.forEach((key) => {
    deleteSelection.value[key] = shouldCheckAll;
  });
};

const closeDeleteModal = () => {
  showModal.value = false;
  deleteStep.value = 1;
  password.value = "";
  deleteSelection.value = {
    personalInfo: true,
    driverLicense: false,
    vehicle: false,
    routeHistory: false,
    bookingHistory: false,
  };
};

const confirmDelete = async () => {
  if (!password.value) {
    alert("กรุณากรอกรหัสผ่าน");
    return;
  }

  loading.value = true;

  const config = useRuntimeConfig();
  const token =
    useCookie("token").value || (process.client ? localStorage.getItem("token") : "");

  try {
    const res = await fetch(`${config.public.apiBase}/users/me`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify({
        password: password.value,
        exportData: {
          personalInfo: deleteSelection.value.personalInfo,
          driverLicense: dataAvailability.value.driverLicense ? deleteSelection.value.driverLicense : false,
          vehicle: dataAvailability.value.vehicle ? deleteSelection.value.vehicle : false,
          routeHistory: dataAvailability.value.routeHistory ? deleteSelection.value.routeHistory : false,
          bookingHistory: dataAvailability.value.bookingHistory ? deleteSelection.value.bookingHistory : false,
        },
      }),
      credentials: "include",
    });

    const data = await res.json();

     if (!res.ok) {
      if (res.status === 401 || data.message?.toLowerCase().includes("password")) {
        throw new Error("รหัสผ่านไม่ถูกต้อง");
      }
      throw new Error(data.message || "Delete failed");
    }


    // ลบ cookie
    document.cookie = "token=; Max-Age=0; path=/;";
    document.cookie = "user=; Max-Age=0; path=/;";

    const allFalse = Object.values(deleteSelection.value).every(v => v === false);
     if (allFalse) {
    alert("ลบบัญชีสำเร็จ ข้อมูลของคุณจะไม่ถูกส่งไปยัง Email เนื่องจากคุณไม่ได้เลือกข้อมูลใดๆ ในขั้นตอนก่อนหน้า");
  }else {alert("ลบบัญชีสำเร็จ ข้อมูลของคุณได้ถูกส่งไปยัง Email แล้ว");}
    
    await navigateTo("/");
  } catch (err) {
    console.error("Delete error:", err);
    alert("ลบไม่สำเร็จ: " + err.message);
  } finally {
    loading.value = false;
  }
};
</script>
