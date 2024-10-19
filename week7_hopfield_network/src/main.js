import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import * as bootstrap from 'bootstrap/dist/js/bootstrap.bundle';
import dragselect from './dragselect'

const app = createApp(App)
            .provide('bootstrap', bootstrap)
            .directive('drag-select',dragselect)
            .mount('#app');
