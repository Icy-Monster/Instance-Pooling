--!strict
--!native
export type Pool<T> = {
	CreateKey: (self: Pool<T>,Item: Instance ) -> string,
	RetrieveItem: (self: Pool<T>, Key: string) -> Instance?,
	StoreItem: (self: Pool<T>, Key: string, Item: Instance) -> (),
	
	Folder: Folder,
	
	Items: {[string]: {[number]: Instance}}
}

----------------------------------
---------PRIVATE FUNCTIONS--------

local function CreateHex(Length: number, Items: {[string]: {}}): string
	local Hex:string = ""
	
	for _ = 1, Length  do
		Hex = Hex..string.char(math.random(0,255))
	end
	
	--Make sure that the key does not already exist, if it does regenerate it
	if Items[Hex] then return Hex end
	
	return Hex
end

---------PRIVATE FUNCTIONS--------
----------------------------------
----------MAIN FUNCTIONS----------

local Pool = {}
Pool.__index = Pool

local function CreatePool<T>():Pool<T>
	local self:Pool<T> = (setmetatable({}, Pool) :: unknown) :: Pool<T>
			
	self.Folder = Instance.new("Folder", script)
	self.Items = {}
	
	return self
end

--// Creates a Key used to reference to the pool
function Pool:CreateKey(Item: Instance): string
	local Key = CreateHex(16, self.Items)
		
	local Folder = Instance.new("Folder")
	Folder.Name = Key
	Folder.Parent = self.Folder

	local NewItem = Item:Clone()
	NewItem.Parent = Folder

	self.Items[Key] = {}
	table.insert(self.Items[Key], NewItem)
	return Key
end

--// Returns an Instance from the Pool
function Pool:RetrieveItem(Key: string): Instance?
	if not self.Items[Key] then return end
	local Item: Instance

	-- Checks if there are at least 2 items, if so then return the oldest one,
	-- otherwise clone the only one left
	if #self.Items[Key] < 2  then
		Item = self.Items[Key][1]:Clone()
	else
		Item = self.Items[Key][1]
		table.remove(self.Items[Key], 1)
	end

	return Item
end

--// Stores the instance into the pool, to be retrieved later on
function Pool:StoreItem(Key: string, Item: Instance)
	Item.Parent = self.Folder[Key]
	
	table.insert(self.Items[Key], Item)
end

--// Deletes the Pool and all its Items
function Pool:Clear(Key: string)
	self.Items[Key] = nil

	self.Folder[Key]:ClearAllChildren()
end

----------MAIN FUNCTIONS----------
----------------------------------

return {
	New = CreatePool,
}