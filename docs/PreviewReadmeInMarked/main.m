//
//  main.m
//  PreviewReadmeInMarked
//
//  Created by Marco Feltmann on 22.02.20.
//

#import <Foundation/Foundation.h>

// Convenience since strcmp returns 0 when thins are equal, -1 if first is less and 1 if first is more
const int strcmpIsEqual = 0;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSTask * previewTask = [NSTask new];
        
        [previewTask setExecutableURL:[NSURL fileURLWithPath:@"/usr/bin/open"]];
        
        NSURL * applicationDirectory = [[NSBundle mainBundle] executableURL];
        NSURL * readmeFileURL = [applicationDirectory URLByDeletingLastPathComponent];
        
        
        
        NSString * readmePath = [NSString stringWithFormat:@"%@/README.md", [readmeFileURL relativePath]];
        if(readmePath == nil) {
            NSLog(@"Fatal: Unable to find fiel URL for README.md – aborting!");
            return 2;
        }
        
        
        // Start Preview in Chrome
        // Requires a markdown plugin like https://chrome.google.com/webstore/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk
        // You'll need to specifically enable preview of file urls in the plugin, though.
        if(argc != 3) {
            [previewTask setArguments:@[@"-b", @"com.google.Chrome", [NSString stringWithFormat:@"file://%@", readmePath]]];
        }
        // Preview in Marked 2 (macOS payed app) if launch parameters match
        // Add launch parameters `-mode` and `marked2` in the scheme (or enable them…)
        else if(argc == 3 && strcmp(argv[1], "-mode") == strcmpIsEqual && strcmp(argv[2], "marked2") == strcmpIsEqual) {
            [previewTask setArguments:@[[NSString stringWithFormat:@"x-marked://%@", readmePath]]];
        }
        
        NSLog(@"Calling %@ for file %@", [previewTask executableURL], [previewTask arguments]);
        
        [previewTask launch];
    }
    
    return 0;
}
