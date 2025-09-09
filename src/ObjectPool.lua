ObjectPool = Class{}

function ObjectPool:init(size, createFunc)
    self.available = CircularLinkedList()
    self.createFunc = createFunc

    for i = 1, size do
        self.available:enqueue(createFunc())
    end
end

function ObjectPool:acquire()
    local object
    if not self.available:isEmpty() then
        object = self.available:dequeue()
    else
        object = self.createFunc
    end

    return object
end

function ObjectPool:release(object)
    self.available:enqueue(object)
end