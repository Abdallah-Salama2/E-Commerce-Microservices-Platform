import globals from "globals";

export default [
  {
    languageOptions: {
      globals: {
        ...globals.node, // This explicitly tells ESLint that 'process' exists
      },
    },
  },
];
