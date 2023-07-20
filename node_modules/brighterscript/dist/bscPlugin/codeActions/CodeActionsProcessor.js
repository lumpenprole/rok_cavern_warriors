"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CodeActionsProcessor = void 0;
const vscode_languageserver_1 = require("vscode-languageserver");
const CodeActionUtil_1 = require("../../CodeActionUtil");
const DiagnosticMessages_1 = require("../../DiagnosticMessages");
const Parser_1 = require("../../parser/Parser");
const util_1 = require("../../util");
class CodeActionsProcessor {
    constructor(event) {
        this.event = event;
        this.suggestedImports = new Set();
    }
    process() {
        for (const diagnostic of this.event.diagnostics) {
            if (diagnostic.code === DiagnosticMessages_1.DiagnosticCodeMap.cannotFindName) {
                this.suggestCannotFindName(diagnostic);
            }
            else if (diagnostic.code === DiagnosticMessages_1.DiagnosticCodeMap.classCouldNotBeFound) {
                this.suggestClassImports(diagnostic);
            }
            else if (diagnostic.code === DiagnosticMessages_1.DiagnosticCodeMap.xmlComponentMissingExtendsAttribute) {
                this.addMissingExtends(diagnostic);
            }
        }
    }
    /**
     * Generic import suggestion function. Shouldn't be called directly from the main loop, but instead called by more specific diagnostic handlers
     */
    suggestImports(diagnostic, key, files) {
        var _a, _b, _c;
        //skip if we already have this suggestion
        if (this.suggestedImports.has(key)) {
            return;
        }
        this.suggestedImports.add(key);
        const importStatements = this.event.file.parser.references.importStatements;
        //find the position of the first import statement, or the top of the file if there is none
        const insertPosition = (_c = (_b = (_a = importStatements[importStatements.length - 1]) === null || _a === void 0 ? void 0 : _a.importToken.range) === null || _b === void 0 ? void 0 : _b.start) !== null && _c !== void 0 ? _c : util_1.util.createPosition(0, 0);
        //find all files that reference this function
        for (const file of files) {
            const pkgPath = util_1.util.getRokuPkgPath(file.pkgPath);
            this.event.codeActions.push(CodeActionUtil_1.codeActionUtil.createCodeAction({
                title: `import "${pkgPath}"`,
                diagnostics: [diagnostic],
                isPreferred: false,
                kind: vscode_languageserver_1.CodeActionKind.QuickFix,
                changes: [{
                        type: 'insert',
                        filePath: this.event.file.srcPath,
                        position: insertPosition,
                        newText: `import "${pkgPath}"\n`
                    }]
            }));
        }
    }
    suggestCannotFindName(diagnostic) {
        var _a;
        //skip if not a BrighterScript file
        if (diagnostic.file.parseMode !== Parser_1.ParseMode.BrighterScript) {
            return;
        }
        const lowerName = ((_a = diagnostic.data.fullName) !== null && _a !== void 0 ? _a : diagnostic.data.name).toLowerCase();
        this.suggestImports(diagnostic, lowerName, [
            ...this.event.file.program.findFilesForFunction(lowerName),
            ...this.event.file.program.findFilesForClass(lowerName),
            ...this.event.file.program.findFilesForNamespace(lowerName),
            ...this.event.file.program.findFilesForEnum(lowerName)
        ]);
    }
    suggestClassImports(diagnostic) {
        //skip if not a BrighterScript file
        if (diagnostic.file.parseMode !== Parser_1.ParseMode.BrighterScript) {
            return;
        }
        const lowerClassName = diagnostic.data.className.toLowerCase();
        this.suggestImports(diagnostic, lowerClassName, this.event.file.program.findFilesForClass(lowerClassName));
    }
    addMissingExtends(diagnostic) {
        var _a;
        const srcPath = this.event.file.srcPath;
        const { component } = this.event.file.parser.ast;
        //inject new attribute after the final attribute, or after the `<component` if there are no attributes
        const pos = ((_a = component.attributes[component.attributes.length - 1]) !== null && _a !== void 0 ? _a : component.tag).range.end;
        this.event.codeActions.push(CodeActionUtil_1.codeActionUtil.createCodeAction({
            title: `Extend "Group"`,
            diagnostics: [diagnostic],
            isPreferred: true,
            kind: vscode_languageserver_1.CodeActionKind.QuickFix,
            changes: [{
                    type: 'insert',
                    filePath: srcPath,
                    position: pos,
                    newText: ' extends="Group"'
                }]
        }));
        this.event.codeActions.push(CodeActionUtil_1.codeActionUtil.createCodeAction({
            title: `Extend "Task"`,
            diagnostics: [diagnostic],
            kind: vscode_languageserver_1.CodeActionKind.QuickFix,
            changes: [{
                    type: 'insert',
                    filePath: srcPath,
                    position: pos,
                    newText: ' extends="Task"'
                }]
        }));
        this.event.codeActions.push(CodeActionUtil_1.codeActionUtil.createCodeAction({
            title: `Extend "ContentNode"`,
            diagnostics: [diagnostic],
            kind: vscode_languageserver_1.CodeActionKind.QuickFix,
            changes: [{
                    type: 'insert',
                    filePath: srcPath,
                    position: pos,
                    newText: ' extends="ContentNode"'
                }]
        }));
    }
}
exports.CodeActionsProcessor = CodeActionsProcessor;
//# sourceMappingURL=CodeActionsProcessor.js.map