/*
 * LPCalendarHeaderView.j
 * LPKit
 *
 * Created by Ludwig Pettersson on September 21, 2009.
 * 
 * The MIT License
 * 
 * Copyright (c) 2009 Ludwig Pettersson
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

_monthNames = [@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
_dayNamesShort = [@"mon", @"tue", @"wed", @"thu", @"fri", @"sat", @"sun"];
_dayNamesShortUS = [@"sun", @"mon", @"tue", @"wed", @"thu", @"fri", @"sat"];

@implementation LPCalendarHeaderView : CPControl
{
    CPTextField title;
    id prevButton @accessors(readonly);
    id nextButton @accessors(readonly);
    CPArray dayLabels;
    
    BOOL weekStartsOnMonday @accessors;
}

+ (CPString)themeClass
{
    return @"lp-calendar-header-view";
}

- (id)initWithFrame:(CGRect)aFrame
{
    if(self = [super initWithFrame:aFrame])
    {
        title = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        [title setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];
        [self addSubview:title];
        
        prevButton = [[LPCalendarHeaderPreviousButton alloc] initWithFrame:CGRectMake(6, 9, 0, 0)];
        [prevButton sizeToFit];
        [self addSubview:prevButton];
        
        nextButton = [[LPCalendarHeaderNextButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self bounds]) - 21, 9, 0, 0)];
        [nextButton sizeToFit];
        [nextButton setAutoresizingMask:CPViewMinXMargin];
        [self addSubview:nextButton];
        
        dayLabels = [CPArray array];
        
        for (var i = 0; i < [_dayNamesShort count]; i++)
        {
            var label = [LPCalendarLabel labelWithTitle:[_dayNamesShort objectAtIndex:i]];
            [dayLabels addObject:label];
            [self addSubview:label];
        }
        
        [self setBackgroundColor:[CPColor lightGrayColor]];
        
        [self setNeedsLayout];
    }
    return self;
}

- (void)setDate:(CPDate)aDate
{
    [title setStringValue:[CPString stringWithFormat:@"%s %i", _monthNames[aDate.getUTCMonth()], aDate.getUTCFullYear()]];
    [title sizeToFit];
    [title setCenter:CGPointMake(CGRectGetMidX([self bounds]), 16)];
}

- (void)setWeekStartsOnMonday:(BOOL)shouldWeekStartOnMonday
{
    weekStartsOnMonday = shouldWeekStartOnMonday;
    
    var dayNames = (shouldWeekStartOnMonday) ? _dayNamesShort : _dayNamesShortUS;
    
    for (var i = 0; i < [dayLabels count]; i++)
        [[dayLabels objectAtIndex:i] setTitle:[dayNames objectAtIndex:i]];

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    var bounds = [self bounds],
        numberOfLabels = [dayLabels count],
        labelWidth = CGRectGetWidth(bounds) / numberOfLabels,
        labelHeight = CGRectGetHeight([[[self subviews] objectAtIndex:3] bounds]),
        height = CGRectGetHeight(bounds);

    for (var i = 0; i < numberOfLabels; i++)
    {
        [dayLabels[i] setFrame:CGRectMake(i * labelWidth, height - labelHeight, labelWidth, labelHeight)];
    }
    
    var superview = [self superview],
        themeState = [self themeState];
    
    [self setBackgroundColor:[superview valueForThemeAttribute:@"header-background-color" inState:themeState]];
    [title setFont:[superview valueForThemeAttribute:@"header-font" inState:themeState]];
    [title setTextColor:[superview valueForThemeAttribute:@"header-text-color" inState:themeState]];
    [title setTextShadowColor:[superview valueForThemeAttribute:@"header-text-shadow-color" inState:themeState]];
    [title setTextShadowOffset:[superview valueForThemeAttribute:@"header-text-shadow-offset" inState:themeState]];
}

@end

@implementation LPCalendarLabel : CPTextField
{
}

+ labelWithTitle:(CPString)aTitle
{
    var label = [[LPCalendarLabel alloc] initWithFrame:CGRectMakeZero()];
    [label setTitle:aTitle];
    return label;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        [self setValue:CPCenterTextAlignment forThemeAttribute:@"alignment"];
    }
    return self;
}

- (void)setTitle:(CPString)aTitle
{
    [self setStringValue:aTitle];
    [self sizeToFit];
}

- (void)didMoveToSuperview
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    var calendarView = [[self superview] superview],
        themeState = [self themeState];
    
    [self setFont:[calendarView valueForThemeAttribute:@"header-weekday-label-font" inState:themeState]];
    [self setTextColor:[calendarView valueForThemeAttribute:@"header-weekday-label-color" inState:themeState]];
    [self setTextShadowColor:[calendarView valueForThemeAttribute:@"header-weekday-label-shadow-color" inState:themeState]];
    [self setTextShadowOffset:[calendarView valueForThemeAttribute:@"header-weekday-label-shadow-offset" inState:themeState]];
    
    [super layoutSubviews];
}

@end


@implementation LPCalendarHeaderButton : CPButton 
{
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        [self setValue:CGSizeMake(15.0, 15.0) forThemeAttribute:@"min-size"];
        [self setValue:CGSizeMake(15.0, 15.0) forThemeAttribute:@"max-size"];
    }
    return self;
}

@end


@implementation LPCalendarHeaderPreviousButton : LPCalendarHeaderButton 
{
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        var bezelColor = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
                    [
                        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:[self class]] pathForResource:@"LPCalendarView/previous.png"] size:CGSizeMake(15.0, 15.0)], nil, nil
                    ]
                isVertical:NO]];
        
        [self setValue:bezelColor forThemeAttribute:@"bezel-color" inState:CPThemeStateBordered];
    }
    return self;
}

@end

@implementation LPCalendarHeaderNextButton : LPCalendarHeaderButton 
{
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        var bezelColor = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
                    [
                        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:[self class]] pathForResource:@"LPCalendarView/next.png"] size:CGSizeMake(15.0, 15.0)], nil, nil
                    ]
                isVertical:NO]];
        
        [self setValue:bezelColor forThemeAttribute:@"bezel-color" inState:CPThemeStateBordered];
    }
    return self;
}

@end