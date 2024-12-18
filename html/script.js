const app = Vue.createApp({
    data() {
        return {
            showGarage: false,
            vehicles: []
        };
    },
    methods: {
        openGarage() {
            this.showGarage = true;
        },
        closeGarage() {
            this.showGarage = false;
            fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
        },
        loadVehicles(vehicles) {
            this.vehicles = vehicles;
        },
        spawnVehicle(vehicleProps) {
            fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ vehicleProps })
            });
        }
    }
});

let vueInstance = app.mount('#app');

window.addEventListener('message', (event) => {
    const data = event.data;
    console.log('Received message:', JSON.stringify(data, null, 2));

    if (data.action === 'open') {
        vueInstance.openGarage();
    } else if (data.action === 'loadVehicles') {
        vueInstance.loadVehicles(data.vehicles);
    } else if (data.action === 'close') {
        console.log("Closing garage...");
        vueInstance.closeGarage();
    }
});
