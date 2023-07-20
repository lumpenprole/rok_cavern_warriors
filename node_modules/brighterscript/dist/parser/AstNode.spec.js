"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const util_1 = require("../util");
const fsExtra = require("fs-extra");
const Program_1 = require("../Program");
const chai_config_spec_1 = require("../chai-config.spec");
const testHelpers_spec_1 = require("../testHelpers.spec");
const testHelpers_spec_2 = require("../testHelpers.spec");
const reflection_1 = require("../astUtils/reflection");
const Statement_1 = require("./Statement");
describe('AstNode', () => {
    let program;
    beforeEach(() => {
        fsExtra.emptyDirSync(testHelpers_spec_2.tempDir);
        program = new Program_1.Program({
            rootDir: testHelpers_spec_2.rootDir,
            stagingDir: testHelpers_spec_2.stagingDir
        });
        program.createSourceScope(); //ensure source scope is created
    });
    afterEach(() => {
        fsExtra.emptyDirSync(testHelpers_spec_2.tempDir);
        program.dispose();
    });
    describe('findChildAtPosition', () => {
        it('finds deepest AstNode that matches the position', () => {
            const file = program.setFile('source/main.brs', `
                    sub main()
                        alpha = invalid
                        print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                    end sub
                `);
            program.validate();
            (0, testHelpers_spec_1.expectZeroDiagnostics)(program);
            const delta = file.ast.findChildAtPosition(util_1.util.createPosition(3, 52));
            (0, chai_config_spec_1.expect)(delta.name.text).to.eql('delta');
            const foxtrot = file.ast.findChildAtPosition(util_1.util.createPosition(3, 71));
            (0, chai_config_spec_1.expect)(foxtrot.name.text).to.eql('foxtrot');
        });
    });
    describe('findChild', () => {
        it('finds a child that matches the matcher', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha = invalid
                    print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                end sub
            `);
            (0, chai_config_spec_1.expect)(file.ast.findChild((node) => {
                return (0, reflection_1.isAssignmentStatement)(node) && node.name.text === 'alpha';
            })).instanceof(Statement_1.AssignmentStatement);
        });
        it('returns the exact node that matches', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha1 = invalid
                    alpha2 = invalid
                end sub
            `);
            let count = 0;
            const instance = file.ast.findChild((node) => {
                if ((0, reflection_1.isAssignmentStatement)(node)) {
                    count++;
                    if (count === 2) {
                        return true;
                    }
                }
            });
            const expected = file.ast.statements[0].func.body.statements[1];
            (0, chai_config_spec_1.expect)(instance).to.equal(expected);
        });
        it('returns undefined when matcher never returned true', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha = invalid
                    print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                end sub
            `);
            (0, chai_config_spec_1.expect)(file.ast.findChild((node) => false)).not.to.exist;
        });
        it('returns the value returned from the matcher', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha = invalid
                    print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                end sub
            `);
            const secondStatement = file.ast.statements[0].func.body.statements[1];
            (0, chai_config_spec_1.expect)(file.ast.findChild((node) => secondStatement)).to.equal(secondStatement);
        });
        it('cancels properly', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha = invalid
                    print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                end sub
            `);
            let count = 0;
            file.ast.findChild((node, cancelToken) => {
                count++;
                cancelToken.cancel();
            });
            (0, chai_config_spec_1.expect)(count).to.eql(1);
        });
    });
    describe('findAncestor', () => {
        it('returns node when matcher returns true', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha = invalid
                    print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                end sub
            `);
            const secondStatement = file.ast.statements[0].func.body.statements[1];
            const foxtrot = file.ast.findChild((node) => {
                var _a;
                return (0, reflection_1.isDottedGetExpression)(node) && ((_a = node.name) === null || _a === void 0 ? void 0 : _a.text) === 'foxtrot';
            });
            (0, chai_config_spec_1.expect)(foxtrot.findAncestor(reflection_1.isPrintStatement)).to.equal(secondStatement);
        });
        it('returns undefined when no match found', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha = invalid
                    print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                end sub
            `);
            const foxtrot = file.ast.findChild((node) => {
                var _a;
                return (0, reflection_1.isDottedGetExpression)(node) && ((_a = node.name) === null || _a === void 0 ? void 0 : _a.text) === 'foxtrot';
            });
            (0, chai_config_spec_1.expect)(foxtrot.findAncestor(reflection_1.isClassStatement)).to.be.undefined;
        });
        it('returns overridden node when returned in matcher', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha = invalid
                    print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                end sub
            `);
            const firstStatement = file.ast.statements[0].func.body.statements[0];
            const foxtrot = file.ast.findChild((node) => {
                var _a;
                return (0, reflection_1.isDottedGetExpression)(node) && ((_a = node.name) === null || _a === void 0 ? void 0 : _a.text) === 'foxtrot';
            });
            (0, chai_config_spec_1.expect)(foxtrot.findAncestor(node => firstStatement)).to.equal(firstStatement);
        });
        it('returns overridden node when returned in matcher', () => {
            const file = program.setFile('source/main.brs', `
                sub main()
                    alpha = invalid
                    print alpha.beta.charlie.delta(alpha.echo.foxtrot())
                end sub
            `);
            let count = 0;
            const firstStatement = file.ast.statements[0].func.body.statements[0];
            firstStatement.findAncestor((node, cancel) => {
                count++;
                cancel.cancel();
            });
            (0, chai_config_spec_1.expect)(count).to.eql(1);
        });
    });
});
//# sourceMappingURL=AstNode.spec.js.map