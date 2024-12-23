<script setup>
import { ref, watch, computed } from "vue";
import { useI18n } from "vue-i18n";

const { t, locale } = useI18n();

const selectedLocale = ref(locale.value);

const locales = computed(() => [
    { value: "en", label: t("english") },
    { value: "de", label: t("german") },
]);

watch(selectedLocale, (newLocale) => {
    locale.value = newLocale;
});
</script>

<template>
    <div class="flex flex-col items-center space-y-8">
        <h1 class="text-3xl font-bold">{{ t("settings") }}</h1>

        <div class="w-full max-w-md bg-gray-800 rounded-lg shadow-lg divide-y divide-gray-700">
            <!-- Locale Selector -->
            <div class="relative px-6 py-4 hover:bg-gray-700 transition">
                <div class="flex items-center justify-between">
                    <div class="flex flex-col">
                        <span class="text-base font-medium text-white">{{ t("language") }}</span>
                        <span class="text-sm text-gray-400">{{ t("selectLanguage") }}</span>
                    </div>
                </div>
                <!-- Selector -->
                <div class="mt-4 relative">
                    <div class="relative">
                        <div class="relative">
                            <div class="bg-gray-700 border border-gray-600 rounded-lg overflow-hidden">
                                <select
                                    v-model="selectedLocale"
                                    class="appearance-none w-full px-4 py-2 bg-transparent text-sm text-white focus:outline-none focus:ring focus:ring-myscriptsblue2 cursor-pointer transition"
                                >
                                    <option
                                        v-for="locale in locales"
                                        :key="locale.value"
                                        :value="locale.value"
                                        class="text-black"
                                    >
                                        {{ locale.label }}
                                    </option>
                                </select>
                            </div>
                            <div class="absolute inset-y-0 right-3 flex items-center pointer-events-none">
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    fill="none"
                                    viewBox="0 0 24 24"
                                    stroke-width="1.5"
                                    stroke="currentColor"
                                    class="w-4 h-4 text-gray-400"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        d="M19.5 9l-7.5 7.5L4.5 9"
                                    />
                                </svg>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
/* Tooltip styles */
.group:hover .tooltip {
    opacity: 1;
    transform: translateY(0);
}

/* Fix dropdown behavior */
select {
    cursor: pointer;
}

/* Smooth transitions for hover */
.group:hover div {
    opacity: 1;
    visibility: visible;
}

.tooltip {
    position: absolute;
    top: -1rem;
    left: 50%;
    transform: translate(-50%, -10px);
    padding: 0.5rem;
    background-color: rgba(0, 0, 0, 0.8);
    color: #fff;
    font-size: 0.875rem;
    border-radius: 0.375rem;
    opacity: 0;
    transition: all 0.3s ease-in-out;
    white-space: nowrap;
    z-index: 10;
}
</style>
