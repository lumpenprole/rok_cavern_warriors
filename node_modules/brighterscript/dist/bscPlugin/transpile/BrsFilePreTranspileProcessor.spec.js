"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const sinon_1 = require("sinon");
const fsExtra = require("fs-extra");
const Program_1 = require("../../Program");
const util_1 = require("../../util");
const testHelpers_spec_1 = require("../../testHelpers.spec");
const sinon = (0, sinon_1.createSandbox)();
describe('BrsFile', () => {
    let program;
    beforeEach(() => {
        fsExtra.emptyDirSync(testHelpers_spec_1.tempDir);
        program = new Program_1.Program({ rootDir: testHelpers_spec_1.rootDir, sourceMap: true });
    });
    afterEach(() => {
        sinon.restore();
        program.dispose();
    });
    describe('BrsFilePreTranspileProcessor', () => {
        it('does not crash when operating on a file not included by any scope', async () => {
            program.setFile('components/lib.brs', `
                sub doSomething()
                    a = { b: "c"}
                    print a.b
                end sub
            `);
            await program.transpile([], (0, util_1.standardizePath) `${testHelpers_spec_1.tempDir}/out`);
        });
    });
});
//# sourceMappingURL=BrsFilePreTranspileProcessor.spec.js.map