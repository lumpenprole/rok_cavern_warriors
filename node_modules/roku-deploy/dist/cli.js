#!/usr/bin/env node
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("./index");
(0, index_1.deploy)().then((...args) => {
    console.log(...args);
}, (...args) => {
    console.error(...args);
});
//# sourceMappingURL=cli.js.map