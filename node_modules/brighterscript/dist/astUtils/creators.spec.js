"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const chai_config_spec_1 = require("../chai-config.spec");
const __1 = require("..");
const TranspileState_1 = require("../parser/TranspileState");
const creators_1 = require("./creators");
describe('creators', () => {
    describe('createStringLiteral', () => {
        it('wraps the value in quotes', () => {
            (0, chai_config_spec_1.expect)((0, creators_1.createStringLiteral)('hello world').token.text).to.equal('"hello world"');
        });
        it('does not wrap already-quoted value in extra quotes', () => {
            (0, chai_config_spec_1.expect)((0, creators_1.createStringLiteral)('"hello world"').token.text).to.equal('"hello world"');
        });
        it('does not wrap badly quoted value in additional quotes', () => {
            //leading
            (0, chai_config_spec_1.expect)((0, creators_1.createStringLiteral)('"hello world').token.text).to.equal('"hello world');
            //trailing
            (0, chai_config_spec_1.expect)((0, creators_1.createStringLiteral)('hello world"').token.text).to.equal('hello world"');
        });
    });
    describe('interpolatedRange', () => {
        it('can be used in sourcemaps', () => {
            const state = new TranspileState_1.TranspileState('source/main.brs', {});
            const node = state.sourceNode({ range: __1.interpolatedRange }, 'code');
            //should not crash
            node.toStringWithSourceMap();
        });
    });
});
//# sourceMappingURL=creators.spec.js.map