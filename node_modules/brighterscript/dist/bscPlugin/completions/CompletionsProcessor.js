"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CompletionsProcessor = void 0;
const reflection_1 = require("../../astUtils/reflection");
const TokenKind_1 = require("../../lexer/TokenKind");
const util_1 = require("../../util");
class CompletionsProcessor {
    constructor(event) {
        this.event = event;
    }
    process() {
        let completionsArray = [];
        if ((0, reflection_1.isBrsFile)(this.event.file) && this.event.file.isPositionNextToTokenKind(this.event.position, TokenKind_1.TokenKind.Callfunc)) {
            const xmlScopes = this.event.program.getScopes().filter((s) => (0, reflection_1.isXmlScope)(s));
            // is next to a @. callfunc invocation - must be an interface method.
            //TODO refactor this to utilize the actual variable's component type (when available)
            for (const scope of xmlScopes) {
                let fileLinks = this.event.program.getStatementsForXmlFile(scope);
                for (let fileLink of fileLinks) {
                    let pushItem = scope.createCompletionFromFunctionStatement(fileLink.item);
                    if (!completionsArray.includes(pushItem.label)) {
                        completionsArray.push(pushItem.label);
                        this.event.completions.push(pushItem);
                    }
                }
            }
            //no other result is possible in this case
            return;
        }
        //find the scopes for this file
        let scopesForFile = this.event.program.getScopesForFile(this.event.file);
        //if there are no scopes, include the global scope so we at least get the built-in functions
        scopesForFile = scopesForFile.length > 0 ? scopesForFile : [this.event.program.globalScope];
        //get the completions from all scopes for this file
        let allCompletions = util_1.util.flatMap(scopesForFile.map(scope => {
            return this.event.file.getCompletions(this.event.position, scope);
        }), c => c);
        //only keep completions common to every scope for this file
        let keyCounts = new Map();
        for (let completion of allCompletions) {
            let key = `${completion.label}-${completion.kind}`;
            keyCounts.set(key, keyCounts.has(key) ? keyCounts.get(key) + 1 : 1);
            if (keyCounts.get(key) === scopesForFile.length) {
                this.event.completions.push(completion);
            }
        }
    }
}
exports.CompletionsProcessor = CompletionsProcessor;
//# sourceMappingURL=CompletionsProcessor.js.map