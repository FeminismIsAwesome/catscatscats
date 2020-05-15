import React from "react";

class PlayerMat extends React.Component {
    render = () => {
        const {stats} = this.props;
        return <div>
            <h5> THE PLAYER MAT IS AWESOME</h5>
            <div> CURRENT TREAT COUNT: {stats.treats} </div>
        </div>
    }
}

export default PlayerMat;