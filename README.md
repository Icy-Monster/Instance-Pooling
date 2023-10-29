
# Instance Pooling

This is a simple module to pool instances, with this you can store instances to be used later on instead of fully deleting them.

# Instructions

- To start off, you need to create a pool, this will be used for storing instance groups inside of it
```lua
   local Pool = InstancePool.New()
```

- This is how to create an Item group, it will return a string key that will be used to reference to the Item Group
```lua
    Pool:CreateKey(Instance) :: string
```

- This is how to retrieve an item from the Item Group

```lua
    Pool:RetrieveItem(Key) :: instance
```

- and to reuse the item later on, you will need to store it
```lua
    Pool:StoreItem(Key, Instance)
```

- After you are done using the Item Group you can simply delete it
```lua
    Pool:Clear(Key)
```