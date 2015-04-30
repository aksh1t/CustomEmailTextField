/*
 The MIT License (MIT)
 
 Copyright (c) 2015 Akshat Patel
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or
 sell copies of the Software, and to permit persons to whom the 
 Software is furnished to do so, subject to the following 
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
 OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "TGEmailTextField.h"

@implementation TGKeyboardButton{
    BOOL touched;
}

-(void)setUpLookAndFeel{
    [self.titleLabel setFont: [UIFont systemFontOfSize:14]];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.layer setCornerRadius:5];
    [self.layer setShadowRadius:0.5];
    [self.layer setShadowOffset:CGSizeMake(0, 0.5)];
    [self.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [self.layer setShadowOpacity:0.8];
}

-(instancetype)init{
    self = [super init];
    [self setUpLookAndFeel];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self setUpLookAndFeel];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setUpLookAndFeel];
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        [self select];
    }else{
        [self performSelector:@selector(deselect) withObject:nil afterDelay:0.1];
    }
}

-(void)deselect{
    [self setTransform:CGAffineTransformIdentity];
    [self.layer setShadowOpacity:0.8];
}

-(void)select{
    [self setTransform:CGAffineTransformMakeTranslation(0, 0.5)];
    [self.layer setShadowOpacity:0.0];
}

@end

@implementation TGEmailTextField

-(instancetype)init{
    self = [super init];
    self.keyboardType = UIKeyboardTypeEmailAddress;
    self.inputAccessoryView = [self setUpAccessoryView];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.keyboardType = UIKeyboardTypeEmailAddress;
    self.inputAccessoryView = [self setUpAccessoryView];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.keyboardType = UIKeyboardTypeEmailAddress;
    self.inputAccessoryView = [self setUpAccessoryView];
    return self;
}

-(UIView *)setUpAccessoryView{
    int totalWidth = 0;
    
    NSArray *fields = [NSArray arrayWithObjects:@"@gmail.com",@"@yahoo.com",@"@hotmail.com",@"@rediffmail.com",@".com",@".co.in", nil];
    
    inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [inputAccessoryView setBackgroundColor :[UIColor colorWithRed:199.0/255.0 green:203.0/255.0 blue:211.0/255.0 alpha:1]];
    
    scrollView = [[UIScrollView alloc]initWithFrame:inputAccessoryView.frame];
    [inputAccessoryView addSubview:scrollView];
    
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [inputAccessoryView addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"H:|-0-[scrollView]-0-|"
                                        options:NSLayoutFormatDirectionLeadingToTrailing
                                        metrics:nil
                                        views:NSDictionaryOfVariableBindings(scrollView)]];
    [inputAccessoryView addConstraints:[NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-0-[scrollView]-0-|"
                                        options:NSLayoutFormatDirectionLeadingToTrailing
                                        metrics:nil
                                        views:NSDictionaryOfVariableBindings(scrollView)]];
    
    for (NSString *field in fields) {
        TGKeyboardButton *button = [TGKeyboardButton new];
        [button setTitle:field forState:UIControlStateNormal];
        [button sizeToFit];
        [button setCenter:inputAccessoryView.center];
        [button setFrame:CGRectMake(totalWidth, button.frame.origin.y, button.frame.size.width + 20, button.frame.size.height)];
        [button addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        totalWidth += button.frame.size.width + 10;
        [scrollView addSubview:button];
    }
    
    [scrollView setContentSize:CGSizeMake(totalWidth - 10, 40)];
    [scrollView setContentInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    return inputAccessoryView;
}

-(void)touchUpInside:(UIButton *)sender{
    NSRange range = [self.text rangeOfString:@"@"];
    
    if (range.location == NSNotFound) {
        self.text = [NSString stringWithFormat:@"%@%@",self.text,sender.titleLabel.text];
    }else{
        NSString *substr = [self.text substringToIndex:range.location];
        self.text = [NSString stringWithFormat:@"%@%@",substr,sender.titleLabel.text];
    }
}

@end
