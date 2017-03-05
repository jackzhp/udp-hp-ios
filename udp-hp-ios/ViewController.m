//
//  ViewController.m
//  udp-hp-ios
//
//  Created by WAYNE SMALL on 2/26/17.
//  Copyright © 2017 Waynemystir. All rights reserved.
//

#import "ViewController.h"
#import "udp_dev.h"
#import "udp_client.h"

static ViewController *vcs;

void wlog(NSString *w) {
    if (!vcs) {
        NSLog(@"VC-singleton not found");
        return;
    }
    
    if (!vcs.daConsole) {
        NSLog(@"daText not found");
        return;
    }
    
//    unichar last = [vcs.daConsole.text characterAtIndex:([vcs.daConsole.text length] - 1)];
    NSString *s = /*last == '\n' ? @"" :*/ @"\n";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vcs.daConsole setText:[NSString stringWithFormat:@"%@%@%@", vcs.daConsole.text, s, w]];
        NSRange bottom = NSMakeRange(vcs.daConsole.text.length - 1, 1);
        [vcs.daConsole scrollRangeToVisible:bottom];
    });
    
}

void self_info(char *w) {
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void server_info(char *w) {
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void socket_created(int sock_fd) {
    char w[256];
    sprintf(w, "The socket file descriptor is %d", sock_fd);
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void socket_bound(void) {
    char *w = "The socket was bound";
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void sendto_succeeded(size_t bytes_sent) {
    char w[256];
    sprintf(w, "sendto succeeded, %zu bytes sent", bytes_sent);
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void recd(size_t bytes_recd, socklen_t addr_len, char *w) {
    char e[256];
    sprintf(e, "recvfrom %zu %u %s", bytes_recd, addr_len, w);
    printf("%s\n", e);
    wlog([NSString stringWithUTF8String:e]);
}

void coll_buf(char *w) {
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void new_client(char *w) {
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void confirmed_client() {
    char *w = "Confirmed client";
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void new_peer(char *w) {
    printf("%s", w);
    wlog([NSString stringWithUTF8String:w]);
}

void hole_punch_sent(char *w, int t) {
    char wc [256];
    sprintf(wc, "%s count %d", w, t);
    printf("%s\n", wc);
    wlog([NSString stringWithUTF8String:wc]);
}

void confirmed_peer_while_punching(void) {
    char w[] = "*$*$*$*$*$*$*$*$*$*$*$*$* CPWP";
    printf("%s\n", w);
    wlog([NSString stringWithUTF8String:w]);
}

void from_peer(char *w) {
    printf("%s", w);
    wlog([NSString stringWithUTF8String:w]);
}

void unhandled_response_from_server(int w) {
    char wc [100];
    sprintf(wc, "unhandled_response_from_server::%d", w);
    printf("%s", wc);
    wlog([NSString stringWithUTF8String:wc]);
}

void whilew(int w) {
    char wt[256];
    sprintf(wt, "Meanwhile...%d\n", w);
    printf("%s", wt);
    wlog([NSString stringWithUTF8String:wt]);
}

void end_while(void) {
    char *w = "Ending while looping***************\n";
    printf("%s", w);
    wlog([NSString stringWithUTF8String:w]);
}

@interface ViewController () <UITextViewDelegate>

@end

@implementation ViewController

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [textView resignFirstResponder];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    vcs = self;
    self.daConsole.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)tapPing:(id)sender {
    printf("tapPing\n");
    ((UIButton *)sender).backgroundColor = [UIColor purpleColor];
    char *w = send_ping();
    wlog([NSString stringWithUTF8String:w]);
}

- (IBAction)tapHolePunch:(id)sender {
    ((UIButton *)sender).backgroundColor = [UIColor purpleColor];
    wlog(@"tapHolePunch");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        wain(self_info,
             server_info,
             socket_created,
             socket_bound,
             sendto_succeeded,
             recd,
             coll_buf,
             new_client,
             confirmed_client,
             new_peer,
             hole_punch_sent,
             confirmed_peer_while_punching,
             from_peer,
             unhandled_response_from_server,
             whilew,
             end_while);
    });
}

- (IBAction)tapPingAllPeers:(id)sender {
    ((UIButton *)sender).backgroundColor = [UIColor purpleColor];
    wlog(@"tapPingAllPeers");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ping_all_peers();
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
