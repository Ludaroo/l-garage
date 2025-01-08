<script setup>
import { ref, onMounted } from 'vue';
import PublicGarage from './components/PublicGarage.vue'; 

const displayUI = {
  publicgarage: ref(false),
};


if (process.env.NODE_ENV === 'development') {
  displayUI.publicgarage.value = true;
}


onMounted(() => {
  window.addEventListener('message', (event) => {
   // console.log(event.data.type)
    if (event.data.type != null) {
      if (displayUI[event.data.type] !== undefined & displayUI[event.data.type].value !== undefined) {
        console.log(event.data.type)
          displayUI[event.data.type].value = event.data.type;
      }
    }
  });
});
</script>

<template>
  <PublicGarage v-if="displayUI.publicgarage.value"/> 
</template>
