CREATE TABLE [dbo].[CommercialGLPolicy] (
    [PolicyId]       INT           NOT NULL,
    [PolicyNbr]      VARCHAR (16)  NOT NULL,
    [CreatedTmstmp]  DATETIME      NOT NULL,
    [UserCreatedId]  CHAR (8)      NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL,
    [SourceSystemCd] CHAR (2)      NOT NULL,
    CONSTRAINT [PK_CommercialGLPolicy] PRIMARY KEY CLUSTERED ([PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLPolicy_CommercialPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[CommercialPolicy] ([PolicyId])
) ON [POLICYCD];

