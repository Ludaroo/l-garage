<script setup>
import { ref, reactive, computed } from 'vue';
import { useStore } from 'vuex';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';


const store = useStore();
const locations = computed(() => store.state.config.locationsConfig);
const displayDialog = ref(false);
const selectedLocation = reactive({
  name: '',
  label: '',
  camTransitionTime: 0,
  allowedJobs: [],
  allowedIdentifiers: [],
  allowedGroups: [],
  coords: []
});
const newCoord = reactive({
  ped: { x: 0, y: 0, z: 0, h: 0 },
  animation: { dict: '', anim: '' },
  camera: { x: 0, y: 0, z: 0, rotX: 0, rotY: 0, rotZ: 0 },
  vehicle: { x: 0, y: 0, z: 0, h: 0, model: '' }
});

const openDialog = (location) => {
  Object.assign(selectedLocation, {
    name: location.name ?? '',
    label: location.label ?? '',
    camTransitionTime: location.camTransitionTime ?? 0,
    allowedJobs: location.allowedJobs ?? [],
    allowedIdentifiers: location.allowedIdentifiers ?? [],
    allowedGroups: location.allowedGroups ?? [],
    coords: location.coords?.map(coord => ({
      ped: coord.ped ?? { x: 0, y: 0, z: 0, h: 0 },
      animation: {
        dict: coord.animation?.dict ?? '',
        anim: coord.animation?.anim ?? '',
      },
      camera: coord.camera ?? { x: 0, y: 0, z: 0, rotX: 0, rotY: 0, rotZ: 0 },
      vehicle: coord.vehicle ?? { x: 0, y: 0, z: 0, h: 0, model: '' }
    })) ?? []
  });
  displayDialog.value = true;
};

const saveLocation = () => {
  const index = locations.value.findIndex(loc => loc.name === selectedLocation.name);
  if (index !== -1) {
    store.commit('updateLocation', { index, data: { ...selectedLocation } });
  } else {
    store.commit('addLocation', { ...selectedLocation });
  }
  displayDialog.value = false;
};

const addCoord = () => {
  selectedLocation.coords.push(JSON.parse(JSON.stringify(newCoord)));
};

const removeCoord = (index) => {
  selectedLocation.coords.splice(index, 1);
};
</script>

<template>
    <div>
      <!-- DataTable -->
      <DataTable :value="locations" :tableStyle="{ minWidth: '50rem' }">
        <Column field="name" header="Name"></Column>
        <Column field="label" header="Label"></Column>
        <Column header="Actions" bodyClass="text-center">
          <template #body="slotProps">
            <Button icon="pi pi-pencil" @click="openDialog(slotProps.data)" />
          </template>
        </Column>
      </DataTable>
  
      <!-- Dialog -->
      <Dialog v-model:visible="displayDialog" header="Edit Location" :modal="true" :closable="true" :style="{ width: '80vw' }">
      
      </Dialog>
    </div>
  </template>
  

  