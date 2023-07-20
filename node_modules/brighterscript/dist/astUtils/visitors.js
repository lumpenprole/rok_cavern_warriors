"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WalkMode = exports.InternalWalkMode = exports.createVisitor = exports.walkArray = exports.walk = exports.walkStatements = void 0;
const reflection_1 = require("./reflection");
/**
 * Walks the statements of a block and descendent sub-blocks, and allow replacing statements
 */
function walkStatements(statement, visitor, cancel) {
    statement.walk(visitor, {
        walkMode: WalkMode.visitStatements,
        cancel: cancel
    });
}
exports.walkStatements = walkStatements;
/**
 * A helper function for Statement and Expression `walkAll` calls.
 */
function walk(owner, key, visitor, options, parent) {
    var _a, _b;
    //stop processing if canceled
    if ((_a = options.cancel) === null || _a === void 0 ? void 0 : _a.isCancellationRequested) {
        return;
    }
    //the object we're visiting
    let element = owner[key];
    if (!element) {
        return;
    }
    //link this node to its parent
    element.parent = parent !== null && parent !== void 0 ? parent : owner;
    //notify the visitor of this element
    if (element.visitMode & options.walkMode) {
        const result = visitor === null || visitor === void 0 ? void 0 : visitor(element, element.parent, owner, key);
        //replace the value on the parent if the visitor returned a Statement or Expression (this is how visitors can edit AST)
        if (result && ((0, reflection_1.isExpression)(result) || (0, reflection_1.isStatement)(result))) {
            if (options.editor) {
                options.editor.setProperty(owner, key, result);
            }
            else {
                owner[key] = result;
                //don't walk the new element
                return;
            }
        }
    }
    //stop processing if canceled
    if ((_b = options.cancel) === null || _b === void 0 ? void 0 : _b.isCancellationRequested) {
        return;
    }
    if (!element.walk) {
        throw new Error(`${owner.constructor.name}["${String(key)}"]${parent ? ` for ${parent.constructor.name}` : ''} does not contain a "walk" method`);
    }
    //walk the child expressions
    element.walk(visitor, options);
}
exports.walk = walk;
/**
 * Helper for AST elements to walk arrays when visitors might change the array size (to delete/insert items).
 * @param array the array to walk
 * @param visitor the visitor function to call on match
 * @param options the walk optoins
 * @param parent the parent AstNode of each item in the array
 * @param filter a function used to filter items from the array. return true if that item should be walked
 */
function walkArray(array, visitor, options, parent, filter) {
    for (let i = 0; i < array.length; i++) {
        if (!filter || filter(array[i])) {
            const startLength = array.length;
            walk(array, i, visitor, options, parent);
            //compensate for deleted or added items.
            i += array.length - startLength;
        }
    }
}
exports.walkArray = walkArray;
/**
 * Creates an optimized visitor function.
 * Conventional visitors will need to inspect each incoming Statement/Expression, leading to many if statements.
 * This function will compare the constructor of the Statement/Expression, and perform a SINGLE logical check
 * to know which function to call.
 */
function createVisitor(visitor) {
    //remap some deprecated visitor names TODO remove this in v1
    if (visitor.ClassFieldStatement) {
        visitor.FieldStatement = visitor.ClassFieldStatement;
    }
    if (visitor.ClassMethodStatement) {
        visitor.MethodStatement = visitor.ClassMethodStatement;
    }
    return ((statement, parent, owner, key) => {
        var _a;
        return (_a = visitor[statement.constructor.name]) === null || _a === void 0 ? void 0 : _a.call(visitor, statement, parent, owner, key);
    });
}
exports.createVisitor = createVisitor;
/**
 * An enum used to denote the specific WalkMode options (without
 */
var InternalWalkMode;
(function (InternalWalkMode) {
    /**
     * Walk statements
     */
    InternalWalkMode[InternalWalkMode["walkStatements"] = 1] = "walkStatements";
    /**
     * Call the visitor for every statement encountered by a walker
     */
    InternalWalkMode[InternalWalkMode["visitStatements"] = 2] = "visitStatements";
    /**
     * Walk expressions.
     */
    InternalWalkMode[InternalWalkMode["walkExpressions"] = 4] = "walkExpressions";
    /**
     * Call the visitor for every expression encountered by a walker
     */
    InternalWalkMode[InternalWalkMode["visitExpressions"] = 8] = "visitExpressions";
    /**
     * If child function expressions are encountered, this will allow the walker to step into them.
     */
    InternalWalkMode[InternalWalkMode["recurseChildFunctions"] = 16] = "recurseChildFunctions";
})(InternalWalkMode = exports.InternalWalkMode || (exports.InternalWalkMode = {}));
/* eslint-disable @typescript-eslint/prefer-literal-enum-member */
var WalkMode;
(function (WalkMode) {
    /**
     * Walk statements, but does NOT step into child functions
     */
    WalkMode[WalkMode["walkStatements"] = 1] = "walkStatements";
    /**
     * Walk and visit statements, but does NOT step into child functions
     */
    WalkMode[WalkMode["visitStatements"] = 3] = "visitStatements";
    /**
     * Walk expressions, but does NOT step into child functions
     */
    WalkMode[WalkMode["walkExpressions"] = 4] = "walkExpressions";
    /**
     * Walk and visit expressions of the statement, but doesn't walk child statements
     */
    WalkMode[WalkMode["visitLocalExpressions"] = 12] = "visitLocalExpressions";
    /**
     * Walk and visit expressions, but does NOT step into child functions
     */
    WalkMode[WalkMode["visitExpressions"] = 13] = "visitExpressions";
    /**
     * Visit all descendent statements and expressions, but does NOT step into child functions
     */
    WalkMode[WalkMode["visitAll"] = 15] = "visitAll";
    /**
     * If child function expressions are encountered, this will allow the walker to step into them.
     * This includes `WalkMode.walkExpressions`
     */
    WalkMode[WalkMode["recurseChildFunctions"] = 20] = "recurseChildFunctions";
    /**
     * Visit all descendent statements, and DOES step into child functions
     */
    WalkMode[WalkMode["visitStatementsRecursive"] = 23] = "visitStatementsRecursive";
    /**
     * Visit all descendent expressions, and DOES step into child functions
     */
    WalkMode[WalkMode["visitExpressionsRecursive"] = 29] = "visitExpressionsRecursive";
    /**
     * Visit all descendent statements and expressions, and DOES step into child functions
     */
    WalkMode[WalkMode["visitAllRecursive"] = 31] = "visitAllRecursive";
})(WalkMode = exports.WalkMode || (exports.WalkMode = {}));
//# sourceMappingURL=visitors.js.map