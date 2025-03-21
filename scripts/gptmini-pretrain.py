#!/usr/bin/env python3

import argparse
import requests
import openai
import json
import re


class GPT_DataPrep():

    final_output = []

    def __init__(self, url, data_field='output', n=8,
                 outfile='results.json', model='gpt-4o-mini',
                 batchlen=4, maxtokens=8192, temp=0.7):
        self.url = url
        self.outfile = outfile
        self.model = model
        self.maxtokens = maxtokens
        self.temp = temp
        self.data_field = data_field
        self.n = n
        self.batchlen = batchlen
        self.context = '''
### Instruction:
Based on the following extract, generate five instruction-answer pairs.
Each instruction must ask to write about a specific topic contained in
the context.
Each answer can provide up to three relevant paragraphs based on the information
found in the context.
Only use concepts from the context to generate the instructions.
Instructions must never explicitly mention a context,
a system, a course, or an extract.
Instructions must be self-contained and general.
Answers must imitate the writing style of the context.

Provide your response in JSON format with the following structure:

[
    {{"instruction": "...", "output": "..."}},
]

### Input:
{}
'''
        return

    def run(self):
        print(f'[*] Fetching URL: [{self.url}]')
        r = requests.get(self.url)
        data = json.loads(r.text)
        print(f'[*] Processing #{len(data)} records of content')

        messages = []
        for i, line in enumerate(data):
            try:
                if i and not i % self.batchlen:
                    resp = self.query_model(messages)
                    self.process_responses(i, resp)
                    messages = []
                    self.write_outfile()
                prompt = self.context.format(line[self.data_field])
                messages.append({
                    'role': 'user',
                    'content': prompt})
            except KeyboardInterrupt:
                print('\r\n[+] CTRL-C interrupt!')
                self.write_outfile()
                ans = input('[+] Continue (Y|N)?')
                if len(ans) > 0 and ans.upper()[0] == 'N':
                    break
        self.write_outfile()

    def write_outfile(self):
        with open(self.outfile, 'wt') as ofh:
            print(f'[+] Writing output file [{self.outfile}]')
            ofh.write((json.dumps(self.final_output, indent=4)))

    def process_responses(self, i, resp):
        for j, r in enumerate(resp):
            print(f'[+] Processing #{i:04d}.{j}')
            try:
                content = r.message.content.strip()
                if content.startswith('```json'):
                    output = json.loads(content[7:-3])
                else:
                    output = json.loads(content)
                for k in output:
                    self.final_output.append(k)
            except Exception as e:
                print(f'[-] Error: {e} ({r.message.content.strip()[:30]})')

    def query_model(self, messages):
        response = openai.chat.completions.create(
            model=self.model,
            messages=messages,
            max_tokens=self.maxtokens,
            temperature=self.temp,
            n=self.n
        )
        return response.choices


if __name__ == '__main__':

    def regex_type(pattern: str | re.Pattern):
        def check_regex(arg_value):  
            if not re.match(pattern, arg_value):
                raise argparse.ArgumentTypeError("invalid value")
            return arg_value
        return check_regex

    print('''

[*]----------------------------------------------------------
[*]      ____ ____ _____ __  __ _       _       _  _         
[*]     / ___|  _ \_   _|  \/  (_)_ __ (_)     | || |   ___  
[*]    | |  _| |_) || | | |\/| | | '_ \| |_____| || |_ / _ \ 
[*]    | |_| |  __/ | | | |  | | | | | | |_____|__   _| (_) |
[*]     \____|_|    |_|_|_|  |_|_|_| |_|_|        |_|  \___/ 
[*]    |  _ \ _ __ __|_   _| __ __ _(_)_ __                  
[*]    | |_) | '__/ _ \| || '__/ _` | | '_ \                 
[*]    |  __/| | |  __/| || | | (_| | | | | |                
[*]    |_|   |_|  \___||_||_|  \__,_|_|_| |_|                
[*]                                                     
[*]
[*]     Author: Joff Thyer (c) 2024
[*]     Black Hills Information Security LLC
[*]     RiverGum Security LLC
[*]
[*]----------------------------------------------------------

''')

    parser = argparse.ArgumentParser()
    parser.add_argument(
        'url', type=regex_type(r'https?://[a-zA-Z0-9\-\.]+'),
        help='URL to fetch content from')
    parser.add_argument(
        '-o', '--outfile', default='results.json',
        help='JSON results output filename (default:results.json)')
    parser.add_argument(
        '-m', '--maxtokens', type=int, default=8192,
        help='Maximum number of tokens to generate')
    args = parser.parse_args()
    GPT_DataPrep(
        args.url,
        maxtokens=args.maxtokens,
        outfile=args.outfile).run()
