// src/index.js
import {StrictMode} from "react";
import Row from 'react-bootstrap/Row';
import Container from 'react-bootstrap/Container';
import ReactDOM from "react-dom";
import React from "react";
import App from "./App";

class Main extends React.Component {
    constructor(props) {
        super(props);

        let link_obj = document.createElement("link");
        link_obj.rel = "stylesheet"

        this.state = {
            link_obj: link_obj
        };

        this.switchTheme = this.switchTheme.bind(this);
    }

    componentDidMount() {
        document.head.appendChild(this.state.link_obj);
        window.addEventListener("hashchange", this.switchTheme, false);
    }

    componentWillUnmount() {
        window.removeEventListener("hashchange", this.switchTheme, false);
    }

    switchTheme() {
        this.setState((prevState) => {
            let href = `https://cdn.jsdelivr.net/npm/darkmode-css@1.0.1/${
                window.location.hash.replace("#", '')
            }-mode.css`;
            prevState.link_obj.href = href;
            return {}
        });
    }

    render() {
        return (
            <div>
                <header>
                    <Container>
                        <br/>
                        <Row>
                            <h1>Lock Screen</h1>
                            <em>Enter emo-pin to continue...</em>
                            <hr/>
                        </Row>
                    </Container>
                </header>
                <App/>
                <footer>
                    Made with ❤️ in India. 🇮🇳
                </footer>
            </div>
        );
    }
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render (
    <Main/>);
