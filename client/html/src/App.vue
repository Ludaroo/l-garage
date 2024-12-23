<script setup>
import { ref, onMounted } from 'vue';
import Config from './components/Config.vue'; 

const displayUI = {
  config: ref(false),
};


if (process.env.NODE_ENV === 'development') {
  displayUI.config.value = true;
}


onMounted(() => {
  window.addEventListener('message', (event) => {
   // console.log(event.data.type)
    if (event.data.type != null) {
      if (displayUI[event.data.type] !== undefined & displayUI[event.data.type].value !== undefined) {
        //console.log(event.data.display)
          displayUI[event.data.type].value = event.data.display;
      }
    }
  });
});
</script>

<template>
  
  <Config v-if="displayUI.config.value"></Config> 
</template>
