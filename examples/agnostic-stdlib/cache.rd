interface Cache<T>
    get(String): Optional<T>
    set(String, T, Optional<Number>): Optional<T>
    has(String): Boolean
    delete(String): Result<Void>
    clear(): Result<Void>
    wrap(String, () => T)
