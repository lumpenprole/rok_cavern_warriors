"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DiagnosticFilterer = void 0;
const path = require("path");
const minimatch = require("minimatch");
const util_1 = require("./util");
class DiagnosticFilterer {
    /**
     * Filter a list of diagnostics based on the provided filters
     */
    filter(options, diagnostics) {
        this.filters = this.getDiagnosticFilters(options);
        this.rootDir = options.rootDir;
        this.groupByFile(diagnostics);
        for (let filter of this.filters) {
            this.filterAllFiles(filter);
        }
        let result = this.getDiagnostics();
        //clean up
        delete this.byFile;
        delete this.rootDir;
        delete this.filters;
        return result;
    }
    /**
     * Iterate over all remaining diagnostics from the byFile map.
     * Also removes duplicates
     */
    getDiagnostics() {
        //combine all remaining diagnostics
        let finalDiagnostics = [];
        for (let key in this.byFile) {
            let fileDiagnostics = this.byFile[key];
            for (let diagnostic of fileDiagnostics) {
                if (finalDiagnostics.includes(diagnostic)) {
                    //do not include duplicate diagnostics
                }
                else {
                    finalDiagnostics.push(diagnostic);
                }
            }
        }
        return finalDiagnostics;
    }
    /**
     * group the diagnostics by file
     */
    groupByFile(diagnostics) {
        var _a, _b, _c;
        this.byFile = {};
        for (let diagnostic of diagnostics) {
            const srcPath = (_b = (_a = diagnostic === null || diagnostic === void 0 ? void 0 : diagnostic.file) === null || _a === void 0 ? void 0 : _a.srcPath) !== null && _b !== void 0 ? _b : (_c = diagnostic === null || diagnostic === void 0 ? void 0 : diagnostic.file) === null || _c === void 0 ? void 0 : _c.srcPath;
            //skip diagnostics that have issues
            if (!srcPath) {
                continue;
            }
            const lowerSrcPath = srcPath.toLowerCase();
            //make a new array for this file if one does not yet exist
            if (!this.byFile[lowerSrcPath]) {
                this.byFile[lowerSrcPath] = [];
            }
            this.byFile[lowerSrcPath].push(diagnostic);
        }
    }
    filterAllFiles(filter) {
        let matchedFilePaths;
        //if there's a src, match against all files
        if (filter.src) {
            //prepend rootDir to src if the filter is a relative path
            let src = (0, util_1.standardizePath)(path.isAbsolute(filter.src) ? filter.src : `${this.rootDir}/${filter.src}`);
            matchedFilePaths = minimatch.match(Object.keys(this.byFile), src, {
                nocase: true
            });
            //there is no src; this applies to all files
        }
        else {
            matchedFilePaths = Object.keys(this.byFile);
        }
        //filter each matched file
        for (let filePath of matchedFilePaths) {
            this.filterFile(filter, filePath);
        }
    }
    filterFile(filter, filePath) {
        //if there are no codes, throw out all diagnostics for this file
        if (!filter.codes) {
            //remove this file from the list because all of its diagnostics were removed
            delete this.byFile[filePath];
            //filter any diagnostics with matching codes
        }
        else {
            let fileDiagnostics = this.byFile[filePath];
            for (let i = 0; i < fileDiagnostics.length; i++) {
                let diagnostic = fileDiagnostics[i];
                if (filter.codes.includes(diagnostic.code)) {
                    //remove this diagnostic
                    fileDiagnostics.splice(i, 1);
                    //repeat this loop iteration (with the new item at this index)
                    i--;
                }
            }
        }
    }
    getDiagnosticFilters(config1) {
        var _a, _b;
        let globalIgnoreCodes = [...(_a = config1.ignoreErrorCodes) !== null && _a !== void 0 ? _a : []];
        let diagnosticFilters = [...(_b = config1.diagnosticFilters) !== null && _b !== void 0 ? _b : []];
        let result = [];
        for (let filter of diagnosticFilters) {
            if (typeof filter === 'number') {
                globalIgnoreCodes.push(filter);
                continue;
            }
            else if (typeof filter === 'string') {
                filter = {
                    src: filter
                };
                //if this is a code-only filter, add them to the globalCodes array (and skip adding it now)
            }
            else if (Array.isArray(filter === null || filter === void 0 ? void 0 : filter.codes) && !filter.src) {
                globalIgnoreCodes.push(...filter.codes);
                continue;
            }
            //if this looks like a filter, keep it
            if ((filter === null || filter === void 0 ? void 0 : filter.src) || (filter === null || filter === void 0 ? void 0 : filter.codes)) {
                result.push(filter);
            }
        }
        //include a filter for all global ignore codes
        if (globalIgnoreCodes.length > 0) {
            result.push({
                codes: globalIgnoreCodes
            });
        }
        return result;
    }
}
exports.DiagnosticFilterer = DiagnosticFilterer;
//# sourceMappingURL=DiagnosticFilterer.js.map