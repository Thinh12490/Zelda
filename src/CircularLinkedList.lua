CircularLinkedList = Class{}

function CircularLinkedList:init()
    self.front = nil
    self.rear = nil
end

function CircularLinkedList:enqueue(value)
    local newNode = Node(value)
    if not self.front then
        self.front = newNode
        self.rear = newNode
        newNode.next = newNode
    else
        self.rear.next = newNode
        newNode.next = self.front
        self.rear = newNode
    end
end

function CircularLinkedList:dequeue()
    if not self.front then
        return nil
    end
    local value = self.front.value
    if self.front == self.rear then
        self.front = nil
        self.rear = nil
    else
        self.front = self.front.next
        self.rear.next = self.front
    end
    return value
end

function CircularLinkedList:isEmpty()
    return self.front == nil
end

