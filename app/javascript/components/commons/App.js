import React, { Component } from 'react'
import { DevView } from './index.js'
import 'babel-polyfill'
import 'babel-polyfill'
import 'stylesheets/bootstrap/bootstrap.min.css';

class App extends Component {

  constructor(props) {
    super(props)
  }

  render() {
    return (
        <div className="container">
            {this.props.children}
            {(!process.env.NODE_ENV || process.env.NODE_ENV === 'development') ?
            <DevView props={this.props.appProps} /> : null}
        </div>
    )
  }
}

export default App;
