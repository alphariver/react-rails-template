import React, { Component } from 'react'
import {
    AppBar, Toolbar, Typography, Button, IconButton, Menu
} from '@material-ui/core';

class Header extends Component {

    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div style={styles.root}>
                <AppBar position="sticky" color="default">
                    <Toolbar>
                        <Typography variant="title" color="inherit" style={styles.flex}>
                            <Button size="large" href="/">
                                <span style={styles.titleText}>Home</span>
                            </Button>
                        </Typography>
                        <Button href="/users/sign_in" color="inherit">Login</Button>
                    </Toolbar>
                </AppBar>
            </div>
        )
    }
}

const styles = {
    root: {
      flexGrow: 1,
    },
    titleText: {
        fontSize: '22px'
    },
    flex: {
      flex: 1,
    },
    menuButton: {
      marginLeft: -12,
      marginRight: 20,
    },
  };

export default Header