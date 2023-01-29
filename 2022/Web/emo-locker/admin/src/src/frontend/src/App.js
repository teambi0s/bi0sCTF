import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import React from 'react';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Emoji from 'a11y-react-emoji'
import Modal from 'react-bootstrap/Modal';

class LockScreen extends React.Component {
    constructor(props) {
        super(props);
        this.HOST = "";

        this.state = {
            keys: [],
            pin: [],
            DataisLoaded: false,
            message: "",
            username: ""
        }

    }

    addClick = (e) => {
        e.target.innerHTML = ""

        this.setState((prevState) => {
            let pin = prevState.pin;
            pin.push(parseInt(e.target.getAttribute("aria-label")));
            return {pin: pin}
        })
    }

    passwordStar = () => {
        let password = ""
        for (let index = 0; index < this.state.pin.length; index++) {
            password += "*";
        }
        return password;
    }

    handleClose = () => {
        this.setState(() => {
            return {message: ""}
        })
    }

    showModal = () => {
        if (this.state.message != "") {
            return (
                <Modal show={true}
                    onHide={
                        this.handleClose
                    }
                    backdrop="static"
                    keyboard={false}>
                    <Modal.Header closeButton>
                        <Modal.Title>Information</Modal.Title>
                    </Modal.Header>
                    <Modal.Body> {
                        this.state.message
                    } </Modal.Body>
                    <Modal.Footer>
                        <Button variant="secondary"
                            onClick={
                                this.handleClose
                        }>
                            Close
                        </Button>
                    </Modal.Footer>
                </Modal>
            )
        }
    }

    updateUsernameValue = (e) => {
        this.setState({username: e.target.value});
    }

    attemptRegister = (e) => {
        this.setState(() => {
            return {DataisLoaded: false}
        });

        const requestOptions = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(
                {"username": this.state.username, "pin": this.state.pin}
            )
        };

        fetch(`${
            this.HOST
        }/api/register`, requestOptions).then(response => response.json()).then(data => {
            this.setState({DataisLoaded: true, pin: []});
            if (data.status != "success") {
                this.state.message = data.status;
            } else {
                this.state.message = "Registration success.";
            }
        }).catch(error => {
            this.setState((prevState) => {
                return {DataisLoaded: true, pin: prevState.pin, message: "Could not reach API."}
            });
        })
    }

    attemptLogin = (e) => {
        this.setState(() => {
            return {DataisLoaded: false}
        });

        const requestOptions = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(
                {"username": this.state.username, "pin": this.state.pin}
            )
        };

        fetch(`${
            this.HOST
        }/api/login`, requestOptions).then(response => response.json()).then(data => {
            this.setState({DataisLoaded: true, pin: []});
            this.state.message =  data.status;
        }).catch(error => {
            this.setState((prevState) => {
                return {DataisLoaded: true, pin: prevState.pin, message: "Could not reach API."}
            });
        })
    }

    componentDidMount() {
        fetch(`${
            this.HOST
        }/api/choices`).then((res) => res.json()).then((json) => {
            this.setState({keys: json, DataisLoaded: true});
        });
    }

    render() {
        const {DataisLoaded, keys} = this.state;
        if (!DataisLoaded) 
            return (
                <Container>
                    <Row>
                        Please wait. Loading.
                    </Row>
                </Container>
            );
        


        return (
            <Container> {
                this.showModal()
            }
                <Row>
                    <Col xs={12}>
                        <Form.Control type="text" placeholder="Enter username here.."
                            value={
                                this.state.username
                            }
                            onChange={
                                evt => (this.updateUsernameValue(evt))
                            }/>
                        <br/>
                    </Col>
                </Row>

                <Row>
                    <Col xs={12}>
                        <Form.Control type="text"
                            readOnly={true}
                            disabled={true}
                            value={
                                this.passwordStar()
                            }
                            placeholder="Enter emo-pin and hit submit!"/>
                    </Col>
                </Row>

                <Row>{
                    Object.keys(keys).map((e, i) => (
                        <Col xs={1}>
                            <Emoji symbol={
                                    keys[e]
                                }

                                label={e}
                                onClick={
                                    this.addClick
                                }/>
                        </Col>
                    ))
                } </Row>
                <Row>
                    <Col md={6}>
                        <br/>
                        <Button variant='block btn-info'
                            onClick={
                                this.attemptLogin
                        }>Login</Button>
                    </Col>
                    <Col md={6}>
                        <br/>
                        <Button variant='block btn-warning'
                            onClick={
                                this.attemptRegister
                        }>Register</Button>
                    </Col>
                </Row>
            </Container>
        )
    }
}

export default LockScreen;
