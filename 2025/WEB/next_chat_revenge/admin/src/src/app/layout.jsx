import "./globals.css";
import { ThemeProvider } from "@/providers/theme-provider"

export default function RootLayout({ children }) {
  return (
    <html lang="en" data-theme="black" suppressHydrationWarning={true}>
      <body
        className="antialiased"
        suppressHydrationWarning={true}
      >
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
