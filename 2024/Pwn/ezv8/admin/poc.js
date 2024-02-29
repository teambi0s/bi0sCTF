let a = [0, 1, 2, 3, 4];

function empty() { }

function f(p) {
    return a.pop(Reflect.construct(empty, arguments, p));
}

let p = new Proxy(Object, {
    get: () => {
        a[1] = 1.1;
        % DebugPrint(a);
        return Object.prototype;
    }
});

function main(p) {
    return f(p);
}

% PrepareFunctionForOptimization(empty);
% PrepareFunctionForOptimization(f);
% PrepareFunctionForOptimization(main);

main(empty);
main(empty);
% OptimizeFunctionOnNextCall(main);
print(main(p));