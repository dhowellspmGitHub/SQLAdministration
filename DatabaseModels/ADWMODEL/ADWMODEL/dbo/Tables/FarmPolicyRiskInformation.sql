CREATE TABLE [dbo].[FarmPolicyRiskInformation] (
    [PolicyId]       INT            NOT NULL,
    [SequenceNbr]    CHAR (3)       NOT NULL,
    [PolicyNbr]      VARCHAR (16)   NOT NULL,
    [RatingFctr]     DECIMAL (4, 3) NULL,
    [RateFieldNm]    VARCHAR (50)   NULL,
    [CreatedTmstmp]  DATETIME       NOT NULL,
    [UserCreatedId]  CHAR (8)       NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]  CHAR (8)       NOT NULL,
    [LastActionCd]   CHAR (1)       NOT NULL,
    [SourceSystemCd] CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmPolicyRiskInformation] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyRiskInformation_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyRiskInformation_01]
    ON [dbo].[FarmPolicyRiskInformation]([PolicyId] ASC)
    ON [POLICYCI];

