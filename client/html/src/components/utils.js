// src/utils.js
export const isDev = import.meta.env.DEV;

// Mock GetParentResourceName
export const GetParentResourceName = () => {
  return isDev ? 'mml' : window.GetParentResourceName();
};

// Mock NUI Callbacks
export const fetchNUI = (eventName, data = {}) => {
  if (isDev) {
    // Mock responses for development
    switch (eventName) {
      case 'loadConfig':
        return Promise.resolve({
          cameraConfig: {
            spawnCamera: true,
            cameraType: 'default',
            cameraTransitionTimes: [1000, 1000, 1000],
            cameraHeight: 200,
            firstRegisterCamera: {
              coords: { x: -1004.2181, y: -2675.6194, z: 48.1519 },
              rotX: -10.54,
              rotY: 0.0,
              rotZ: 510.6371,
              fov: 45.0,
            },
            waitTimeOnStart: 1000,
          },
          locationsConfig: [],
          defaultSettings: {},
        });
      case 'saveConfig':
        console.log('Config saved:', data);
        return Promise.resolve();
      default:
        return Promise.resolve();
    }
  } else {
    // Actual NUI callback
    return fetch(`https://${GetParentResourceName()}/${eventName}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data),
    }).then((resp) => resp.json());
  }
};
