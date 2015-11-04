


#-------------------------------------------------------------------------------
# Global Setup -
# Global hooks happen once before any scenario is run.
#
# Starts the specified browser when starting cucumber, before any scenario is
# run.
#-------------------------------------------------------------------------------
result_file = nil
if !ENV["manual"]
    if ENV["firefox"]
        browse = Watir::Browser.new :firefox
        puts "firefox"
    else
        browser = Watir::Browser.new(:remote, :url => "http://localhost:9515")
        puts "chrome"
    end
else
    puts "manual"
end

if ENV["TEST_TYPE"]
    if ENV["TEST_TYPE"].value == "TYPE1"
        file_name_tag ||= "#{JOB_NAME}_#{BUILD_NUMBER}"
    elsif ENV["TEST_TYPE"].value == "TYPE2"
        file_name_tag ||= "#{JOB_NAME}_#{BUILD_NUMBER}_#{TAG}"
    elsif ENV["TEST_TYPE"].value == "TYPE3"
        file_name_tag ||= "#{JOB_NAME}_#{BUILD_NUMBER}"
    end

    puts "file_name_tag = #{file_name_tag}"
else
    puts "undefine test type"
end

if ENV["FILE_NAME_TAG"]
    file_name_tag = ENV["FILE_NAME_TAG"]
end

#-------------------------------------------------------------------------------
# Scenario Setup -
# Before hooks will be run before the first step of each scenario.
# They will run in the same order of which they are registered.
#-------------------------------------------------------------------------------
Before do
    # do something
end

#-------------------------------------------------------------------------------
# Scenario Setup -
# Runs before any scenario step is run.
#-------------------------------------------------------------------------------
Before do | scenario |
    if ENV["CLEAR_RESULT"]
        #create result file, clear if already created
        puts "New result file"
    else
        #append to result file starting from line 3 counting backward
        puts "Existing result file"
    end

    @feature_name = scenario.feature.name
    @scenario_name = scenario.name

    @result_file_name = scenario.feature.name
    if (file_name_tag != nil)
        @result_file_name = @result_file_name + "_" + file_name_tag
    end

    puts "result_file_name = #{@result_file_name}"

    #rf = File.open(@result_file_name, "a")

    
end

#-------------------------------------------------------------------------------
# Scenario Setup -
# Runs before any scenario step is run.
#-------------------------------------------------------------------------------
Before do | scenario |
    ## Feature and scenario name
    #case scenario
        #when Cucumber::Core::Ast::Scenario
            #@feature_name = scenario.feature.name
            #@scenario_name = scenario.name
            #puts "im here"
        #when Cucumber::Core::Ast::ScenarioOutline
            #@feature_name = scenario.scenario_outline.feature.name
            #@scenario_name = scenario.scenario_outline.name
    #end

    @feature_name = scenario.feature.name
    @scenario_name = scenario.name

    # Set result file and update header
    if (result_file == nil)
        result_file = File.open("results/" + @feature_name + ".out", "w")
        result_file.write("\n----------------------------------------");
        result_file.write("----------------------------------------\n");
        result_file.write("Feature: " + @feature_name + "\n");
        result_file.write("----------------------------------------");
        result_file.write("----------------------------------------\n\n");
    end
    @result_file = result_file
    @result_file.write("\n\tScenario: " + scenario.name + "\n\n");
end

#-------------------------------------------------------------------------------
# Scenario Setup -
# Run this before every scenario that is tagged with @watir_demo.
#-------------------------------------------------------------------------------
Before ('@watir_demo') do
    # This is require for every scenario run for steps in other rb file to
    # recognize the browser is not nil.
    @browser = browser
    
    # Assign new value to $ran if it wasn't previously set.
    $at_addr ||= false
    
    if ($at_addr == false)
        step "I go to address http://bit.ly/watir-example"
    end
    
    $at_addr = true
end

#-------------------------------------------------------------------------------
# Scenario Teardown -
# After hooks will be run after the last step of each scenario, even when
# there are failing, undefined, and pending or skipped steps. They will run
# in the opposite order of which they are registered.
# Perform at completion of any scenario.
#-------------------------------------------------------------------------------
After do | scenario |
    # Save scenario PASS/FAIL result


    #step 'I close the browser'
    #@result_file.close
end

#-------------------------------------------------------------------------------
# Around hooks will run around a scenario. This can be used to wrap the
# execution of a scenario in a block. The Around hook receives a scenario
# object and a block (Proc) object.
# The scenario will be executed when you invoke block.call.
#-------------------------------------------------------------------------------
Around ('@fast') do |scenario, block|
    # Scenario tagged with @fast will fail if execution takes longer than 0.5
    # seconds
    Timeout.timeout(0.5) do
        block.call
    end
end

#-------------------------------------------------------------------------------
# Global Teardown -
#-------------------------------------------------------------------------------
at_exit do
    #result_file.write("\n----------------------------------------");
    #result_file.write("----------------------------------------\n");
    #result_file.write("Summary\n");
    #result_file.write("----------------------------------------");
    #result_file.write("----------------------------------------\n");
    #result_file.write("Total Pass      : \n");
    #result_file.write("Total Fail      : \n");
    #result_file.write("Overall Status  : \n\n");
    
    #result_file.close
    browser.close
end
