steps_for :people do
  When "I add a Person" do
    Person.create!(:name => "Foo")
  end
  Then "there should be one person" do
    Person.count.should == 1
  end
end

class Person
  
  # attr_reader :count
  
  @@count = 0
  
  def initialize name
    @name = name
  end
  
  def self.create! name
    self.new name
    @@count += 1
  end

  def self.count
    @@count
  end
  
end