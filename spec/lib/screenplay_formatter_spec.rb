require File.dirname(__FILE__) + '/../spec_helper'

describe ScreenplayFormatter do
  
  describe ".from_text" do
    it "should center character names" do
      ScreenplayFormatter.from_text(" SARAH").should == %Q{<div class="speaker">SARAH</div>\n}
      ScreenplayFormatter.from_text("    GARRETT").should == %Q{<div class="speaker">GARRETT</div>\n}
    end
    
    it "should indent character dialog" do
      ScreenplayFormatter.from_text(" This is some character dialog.").should == %Q{<div class="dialog_line">This is some character dialog.</div>\n}
    end
    
    it "should markup scene locations" do
      ScreenplayFormatter.from_text("1. ROMANTIC LOCATION").should == %Q{<div class="location">1. ROMANTIC LOCATION</div>\n}
    end
    
    it "should markup descriptions" do
      ScreenplayFormatter.from_text("She kisses him fiercely, they embrace with the passion and urgency of human sexuality.").should == %Q{<div class="description">She kisses him fiercely, they embrace with the passion and urgency of human sexuality.</div>\n}
    end
    
    it "should properly markup a screenplay" do
      sample = <<-ENDOFSCREENPLAY
1. PLAYGROUND

This is action text.  This is meant to describe what is happening in the scene.  In this scene, CHARACTER 1 and CHARACTER 2 are having a conversation about SSM.

 CHARACTER 1
 Did you notice the space before my name, as well as the space before this dialogue?

 CHARACTER 2
 Of course I noticed.  That's how SSM works.
ENDOFSCREENPLAY
      marked_up_sample = <<-ENDOFMARKUP
<div class="location">1. PLAYGROUND</div>
<div class="description">This is action text.  This is meant to describe what is happening in the scene.  In this scene, CHARACTER 1 and CHARACTER 2 are having a conversation about SSM.</div>
<div class="speaker">CHARACTER 1</div>
<div class="dialog_line">Did you notice the space before my name, as well as the space before this dialogue?</div>
<div class="speaker">CHARACTER 2</div>
<div class="dialog_line">Of course I noticed.  That's how SSM works.</div>
ENDOFMARKUP

      ScreenplayFormatter.from_text(sample).should == marked_up_sample
    end
  end
end