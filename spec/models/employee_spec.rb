require "spec_helper"

describe Employee do

  describe "searching" do
    it "should find all employees when searching with empty string" do
      Employee.search("").count.should == Employee.count
    end

    it "should search by one word" do
      word = "raymond"
      Employee.search(word).each do |employee|
        [employee.first_name, employee.last_name, employee.email_address, employee.organization_name].any? do |value|
          value.downcase.include?(word)
        end.should be_true
      end
    end

    it "should search by two words" do
      words = ["raymond", "vision"]
      Employee.search(words.join(' ')).each do |employee|
        words.all? do |word|
          [employee.first_name, employee.last_name, employee.email_address, employee.organization_name].any? do |value|
            value.downcase.include?(word)
          end
        end.should be_true
      end
    end
  end

  describe "update" do
    before(:each) do
      User.current = User.find_by_user_name "HRMS"
      @employee = Employee.find_by_email_address("rwelch@vision.com")
    end

    it "should not be valid without first name" do
      @employee.first_name = ""
      @employee.should_not be_valid
    end

    it "should not be valid without last name" do
      @employee.last_name = ""
      @employee.should_not be_valid
    end

    it "should update first name" do
      @employee.last_name.should_not == "Raimonds"
      @employee.last_name = "Raimonds"
      @employee.save.should be_true
      @employee.reload
      @employee.last_name.should == "Raimonds"
    end

    it "should update last name" do
      @employee.last_name.should_not == "Simanovskis"
      @employee.last_name = "Simanovskis"
      @employee.save.should be_true
      @employee.reload
      @employee.last_name.should == "Simanovskis"
    end

    it "should fail without current user" do
      User.current = nil
      @employee.last_name = "Simanovskis"
      expect do
        @employee.save
      end.to raise_error ActiveRecord::StatementInvalid
    end

  end

end