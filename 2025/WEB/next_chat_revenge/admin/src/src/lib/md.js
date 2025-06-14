"use client";

import React from 'react';
import { unified } from 'unified';
import remarkParse from 'remark-parse';
import remarkRehype from 'remark-rehype';
import rehypeReact from 'rehype-react';
import { jsx, jsxs, Fragment } from 'react/jsx-runtime';
import { cn } from '@/lib/utils';
import { Separator } from '@/components/ui/separator';
import { visit } from 'unist-util-visit';

const components = {
  h1: (props) => <h1 {...props} className={cn("text-xl font-bold first:mt-0 text-start", props.className)} />,
  h2: (props) => <h2 {...props} className={cn("text-lg font-semibold mt-5 first:mt-0 text-start", props.className)} />,
  h3: (props) => <h3 {...props} className={cn("text-md font-semibold mt-4 first:mt-0 text-start", props.className)} />,
  p: (props) => <p {...props} className={cn("leading-relaxed text-start", props.className)} />,
  ul: (props) => <ul {...props} className={cn("list-disc pl-6 space-y-1", props.className)} />,
  ol: (props) => <ol {...props} className={cn("list-decimal pl-6 space-y-1", props.className)} />,
  li: (props) => <li {...props} className={cn("leading-relaxed", props.className)} />,
  a: (props) => <a {...props} className={cn("text-blue-500 hover:underline break-words", props.className)} target="_blank" rel="noopener noreferrer" />,
  blockquote: (props) => <blockquote {...props} className={cn("border-l-4 border-muted-foreground/40 pl-4 italic my-4 text-muted-foreground", props.className)} />,
  code: (props) => <code {...props} className={cn("bg-muted/70 px-1.5 py-0.5 rounded text-sm font-mono", props.className)} />,
  pre: (props) => <pre {...props} className={cn("bg-slate-900 text-slate-100 p-4 rounded-lg my-4 overflow-x-auto text-sm", props.className)} />,
  hr: () => <Separator className="my-4" />,
  table: (props) => <div className="overflow-x-auto my-4"><table {...props} className={cn("min-w-full divide-y divide-border", props.className)} /></div>,
  th: (props) => <th {...props} className={cn("px-4 py-2 bg-muted font-medium text-left text-sm", props.className)} />,
  td: (props) => <td {...props} className={cn("px-4 py-2 border-t text-sm", props.className)} />,
  strong: (props) => <strong {...props} className={cn("font-semibold", props.className)} />,
  em: (props) => <em {...props} className={cn("italic", props.className)} />,
  br: () => <br />,
  img: ({ alt, src }) => <>{`![${alt}](${src})`}</>
};

function toText() {
  return (tree) => {
    visit(tree, 'html', (node) => {
      node.type = 'text';
      node.value = node.value;
    });
  };
}

export function RestrictedMarkdown({ content, className }) {
  if (!content || typeof content !== 'string') return null;

  try {
    const processor = unified()
    .use(remarkParse)
    .use(toText)
    .use(remarkRehype)
    .use(rehypeReact, { jsx, jsxs, Fragment, components });

    const parsedContent = processor.processSync(content).result;

    return (
      <div className={cn("prose prose-sm break-words", className)}>
        {parsedContent}
      </div>
    );
  } catch (error) {
    console.error('Error parsing markdown:', error);
    return <p className="leading-relaxed text-start">{content}</p>;
  }
}
