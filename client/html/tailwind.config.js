/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],

  theme: {
    extend: {
      colors: {
        myscriptsblue1: "#4d56a4",
        myscriptsblue2: "#5a86ee",
        myscripts: {
          100: "#f0f4ff",
          200: "#d9e3ff",
          300: "#b7ceff",
          400: "#95b9ff",
          500: "#73a4ff",
          600: "#5a86ee",
          700: "#3f66d6",
          800: "#2e4db0",
          900: "#1f348a",
        }
      },
    },
  },
}