//
//  Segment-MixpanelTests.m
//  Segment-MixpanelTests
//
//  Created by Prateek Srivastava on 11/06/2015.
//  Copyright (c) 2015 Prateek Srivastava. All rights reserved.
//

// https://github.com/Specta/Specta

@import Specta;
@import Expecta;
@import OCMockito;

#import "SEGMixpanelIntegration.h"
#import "SEGPayloadBuilder.h"
#import <MixpanelGroup.h>


SpecBegin(InitialSpecs)

describe(@"Mixpanel Integration", ^{
    __block SEGMixpanelIntegration *integration;
    __block Mixpanel *mixpanel;
    __block MixpanelPeople *mixpanelPeople;
    __block MixpanelGroup *mixpanelGroup;
    
    beforeEach(^{
        mixpanel = mock([Mixpanel class]);
        mixpanelPeople = mock([MixpanelPeople class]);
        [given([mixpanel people]) willReturn:mixpanelPeople];
        
        mixpanelGroup = mock([MixpanelGroup class]);
        
        integration = [[SEGMixpanelIntegration alloc] initWithSettings:@{
                                                                         @"trackAllPages" : @1,
                                                                         @"setAllTraitsByDefault" : @1
                                                                         } andMixpanel:mixpanel];
    });
    
    it(@"track", ^{
        [integration track:[SEGPayloadBuilder track:@"App Opened"]];
        
        [verify(mixpanel) track:@"App Opened" properties:@{}];
    });
    
    it(@"track with properties", ^{
        [integration track:[SEGPayloadBuilder track:@"Viewed Product" withProperties:@{
                                                                                       @"sku" : @"123456"
                                                                                       }]];
        
        [verify(mixpanel) track:@"Viewed Product" properties:@{
                                                               @"sku" : @"123456"
                                                               }];
    });
    
    it(@"track with people", ^{
        [integration setSettings:@{
                                   @"people" : @1
                                   }];
        [integration track:[SEGPayloadBuilder track:@"Purchased Item" withProperties:@{
                                                                                       @"revenue" : @19.99
                                                                                       }]];
        
        [verify(mixpanel) track:@"Purchased Item" properties:@{
                                                               @"revenue" : @19.99
                                                               }];
        [verify(mixpanelPeople) trackCharge:@19.99];
    });
    
    it(@"track with property increments", ^{
        [integration setSettings:@{
                                   @"people" : @1,
                                   @"propIncrements" : @[@"revenue"]
                                   }];
        [integration track:[SEGPayloadBuilder track:@"Purchased Item" withProperties:@{
                                                                                       @"revenue" : @19.99
                                                                                       }]];
        [verify(mixpanel) track:@"Purchased Item" properties:@{
                                                               @"revenue" : @19.99
                                                               }];
    });
    
    it(@"screen", ^{
        [integration screen:[SEGPayloadBuilder screen:@"Home"]];
        
        [verify(mixpanel) track:@"Viewed Home Screen" properties:@{}];
    });
    
    it(@"screen with consolidatedPageCalls", ^{
        [integration setSettings:@{
                                   @"consolidatedPageCalls" : @1
                                   }];
        [integration screen:[SEGPayloadBuilder screen:@"Home"]];
        
        [verify(mixpanel) track:@"Loaded a Screen" properties:@{@"name": @"Home"}];
    });
    
    it(@"identify", ^{
        [integration identify:[SEGPayloadBuilder identify:@"prateek"]];
        
        [verify(mixpanel) identify:@"prateek"];
    });
    
    it(@"identify with traits", ^{
        [integration identify:[SEGPayloadBuilder identify:@"prateek" withTraits:@{
                                                                                  @"firstName" : @"Prateek",
                                                                                  @"lastName" : @"Srivastava",
                                                                                  @"createdAt" : @"",
                                                                                  @"lastSeen" : @"",
                                                                                  @"email" : @"prateek@segment.com",
                                                                                  @"name" : @"prateek srivastava",
                                                                                  @"username" : @"f2prateek",
                                                                                  @"phone" : @"",
                                                                                  @"age" : @24
                                                                                  }]];
        
        [verify(mixpanel) identify:@"prateek"];
        [verify(mixpanel) registerSuperProperties:@{
                                                    @"$first_name" : @"Prateek",
                                                    @"$last_name" : @"Srivastava",
                                                    @"$created" : @"",
                                                    @"$last_seen" : @"",
                                                    @"$email" : @"prateek@segment.com",
                                                    @"$name" : @"prateek srivastava",
                                                    @"$username" : @"f2prateek",
                                                    @"$phone" : @"",
                                                    @"age" : @24
                                                    }];
    });
    
    
    it(@"simple group", ^{
        NSDictionary *groupTraits = @{
                                      @"groupCity" : @"Cairo",
                                      @"name" : @"mixPanelTest1Group"
                                      };
        [integration group:[SEGPayloadBuilder group:@"groupTest1" withTraits:groupTraits]];
        [verify(mixpanel) getGroup:@"mixPanelTest1Group" groupID:@"groupTest1"];
    });
    
    it(@"simple group without name", ^{
        NSDictionary *groupTraits = @{
                                      @"groupCity" : @"Cairo"
                                      };
        [integration group:[SEGPayloadBuilder group:@"groupTest2" withTraits:groupTraits]];
        [verify(mixpanel) getGroup:@"[Segment] Group" groupID:@"groupTest2"];
    });
    
    it(@"simple group setOnce traits", ^{
        [given([mixpanel getGroup:@"[Segment] Group" groupID:@"groupTest2"]) willReturn:mixpanelGroup];
        NSDictionary *groupTraits = @{
                                      @"groupCity" : @"Cairo",
                                      @"groupCount" : @"20"
                                      };
        [integration group:[SEGPayloadBuilder group:@"groupTest2" withTraits:groupTraits]];
        [verify(mixpanelGroup) setOnce:groupTraits];
        [verify(mixpanel) getGroup:@"[Segment] Group" groupID:@"groupTest2"];
    });
    
    it(@"alias", ^{
        [given([mixpanel distinctId]) willReturn:@"123456"];
        [integration alias:[SEGPayloadBuilder alias:@"prateek"]];
        
        [verify(mixpanel) createAlias:@"prateek" forDistinctID:@"123456"];
    });
    
    it(@"flush", ^{
        [integration flush];
        
        [verify(mixpanel) flush];
    });
    
    it(@"reset", ^{
        [integration reset];
        
        [verify(mixpanel) flush];
    });
});

SpecEnd
