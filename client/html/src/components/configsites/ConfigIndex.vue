<script setup>
import { computed, ref } from "vue";
// changelog = ref([ "Initial release", "Added new feature", "Fixed bug" ]);
// Use defineProps to access props in <script setup>

</script>


<template>
<div class="flex flex-col items-center space-y-6">
    <h1 class="text-3xl font-bold">{{ $t("welcomeMessage") }}</h1>
    <p class="text-gray-400">{{ $t("configureSettings") }}</p>

    <div class="w-full max-w-xl p-6 bg-gray-800 rounded-lg shadow-md">
        <h2 class="text-xl font-semibold mb-4">{{ $t("changelog") }}</h2>
        <ul class="space-y-2">
            <!-- <li
                v-for="(entry, index) in changelog"
                :key="index"
                class="p-4 bg-gray-700 rounded-md shadow-sm hover:bg-gray-600 transition"
            >
                {{ entry }}
            </li> -->
            <!-- <li v-if="!changelog.length" class="text-gray-400">
                {{ $t("noChangelogEntries") }}
            </li> -->
        </ul>
    </div>

    <div class="w-full max-w-xl p-6 bg-gray-800 rounded-lg shadow-md mt-6">
        <h2 class="text-xl font-semibold mb-4">{{ $t("selectOption") }}</h2>
        <select class="w-full p-2 bg-gray-700 rounded-md shadow-sm">
            <option value="a">{{ $t("optionA") }}</option>
            <option value="b">{{ $t("optionB") }}</option>
            <option value="c">{{ $t("optionC") }}</option>
        </select>
    </div>
    

</div>
</template>

<style scoped>
ul li {
  transition: background-color 0.2s ease-in-out;
}
</style>